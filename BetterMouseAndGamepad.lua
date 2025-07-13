--- STEAMODDED HEADER
--- MOD_NAME: Better Mouse And Gamepad
--- MOD_ID: BetterMouseAndGamepad
--- MOD_AUTHOR: [Kooluve, uptu]
--- MOD_DESCRIPTION: Makes the mouse and gamepad controls more easy and efficient to use. Among other features, allows the selection of multiple cards by holding `Mouse 2`.
--- PRIORITY: -10000
--- PREFIX: bmag_k
--- VERSION: 1.1.0

----------------------
-- Global variables --
----------------------

-- Steamodded init --
MOD = SMODS.current_mod
C = G.CONTROLLER

-- Event data --
EVENT = {
    m2_click = {
        target = nil,
        prev_target = nil,
    },
    m2_drag = {
        target = nil,
        prev_target = nil,
        active = false,
        allowed = false,
    },
    m2_down = {
        position = {
            x = 0,
            y = 0,
        },
        target = nil,
        time = 0,
    },
    m2_up = {
        position = {
            x = 0,
            y = 0,
        },
        target = nil,
        time = 0.1,
    },
}

-- Input handling flags --
HANDLED = {
    m2_click = true,
    m2_drag = true,
    m3_down_event = true,
    m3_up_event = true,
}

-- Game state data --
STATE = {
    last = G.STATES.SPLASH,
    selecting_hand = false,     -- prevents repetitive playing card and discarding
}

------------------------
-- Love2D Event Hooks --
------------------------

-- Gamepad button press event remapping --
function love.gamepadpressed(joystick, button)
    button = G.button_mapping[button] or button
    button = MOD.config.gamepad_map[button] or button

    -- handle A/B swap if enabled
    if MOD.config.swap_a_with_b then
        if button == 'a' then
            button = 'b'
        elseif button == 'b' then
            button = 'a'
        end
    end

	C:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_press(button)
end

-- Gamepad button release event remapping --
function love.gamepadreleased(joystick, button)
	button = G.button_mapping[button] or button
    button = MOD.config.gamepad_map[button] or button

    -- handle A/B swap if enabled
    if MOD.config.swap_a_with_b then
        if button == 'a' then
            button = 'b'
        elseif button == 'b' then
            button = 'a'
        end
    end

    G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_release(button)
end

-- Mouse button press event override --
function love.mousepressed(x, y, button, touch)
    G.CONTROLLER:set_HID_flags(touch and 'touch' or 'mouse')

    if MOD.config.mouse_map[button] == 'm1' then
        G.CONTROLLER:queue_L_cursor_press(x, y)
    elseif MOD.config.mouse_map[button] == 'm2' then
        G.CONTROLLER:queue_R_cursor_press(x, y)
    elseif MOD.config.mouse_map[button] == 'm3' then
		queue_M_cursor_press()
	end

    local is_m4 = MOD.config.mouse_map[button] == 'm4'
    local is_m5 = MOD.config.mouse_map[button] == 'm5'
    local swapped = MOD.config.swap_m4_with_m5
    local wheel_swapped = MOD.config.swap_m_wheel_with_m4_and_m5

    if
        (is_m4 and not swapped) or
        (is_m5 and swapped)
    then
        if not wheel_swapped then
            queue_m4_cursor_press()
        else
            queue_D_wheel_press()
        end
    elseif 
        (is_m5 and not swapped) or
        (is_m4 and swapped)
    then
        if not wheel_swapped then
            queue_m5_cursor_press()
        else
            queue_U_wheel_press()
        end
    end
end

-- Mouse button release event override --
function love.mousereleased(x, y, button)
    if MOD.config.mouse_map[button] == 'm1' then
        G.CONTROLLER:L_cursor_release(x, y) end
    if MOD.config.mouse_map[button] == 'm2' then
        R_cursor_release(x, y) end
	if MOD.config.mouse_map[button] == 'm3' then
        M_cursor_release(x, y) end
end

-- Mouse wheel movement event override --
function love.wheelmoved(x, y)
    if MOD.config.swap_m_wheel_up_with_down then y = -y end
    if y > 0 then
        if not MOD.config.swap_m_wheel_with_m4_and_m5 then
		    queue_U_wheel_press()
        else
            queue_m5_cursor_press()
        end
    end
    if y < 0 then
        if not MOD.config.swap_m_wheel_with_m4_and_m5 then
		    queue_D_wheel_press()
        else
            queue_m4_cursor_press()
        end
    end
end

local update_old = Controller.update
function Controller.update(self, dt)
    update_old(self, dt)

    -- Determine if player is currently selecting a hand --
    if STATE.last ~= G.STATES.SELECTING_HAND and G.STATE == G.STATES.SELECTING_HAND then
        STATE.selecting_hand = true
    end
    if STATE.last == G.STATES.SELECTING_HAND and G.STATE ~= G.STATES.SELECTING_HAND then
        STATE.selecting_hand = false
    end

    -- Update stored game state --
    STATE.last = G.STATE

    -- If m2 event queue isn't empty, send an event on this game tick --
    if R_cursor_queue then 
        R_cursor_press(R_cursor_queue.x, R_cursor_queue.y)
        R_cursor_queue = nil
    end

    -- If m3 event queue isn't empty, send an event on this game tick --
    if M_cursor_queue then 
        M_cursor_press()
        M_cursor_queue = nil
    end

    -- If a Mouse2 down event hasn't been handled, handle it --
    if not HANDLED.m2_down then
        if MOD.config.multiselect then
            EVENT.m2_drag.allowed = true
        end
        HANDLED.m2_down = true
    end

    -- If not currently dragging, allowed to drag, and clicking on a card... --
    if EVENT.m2_drag.allowed
        and not EVENT.m2_drag.active
        and HANDLED.m2_drag
        and HANDLED.m2_click
        and EVENT.m2_down.target then

        -- ...and if the cursor has moved since clicking, drag until Mouse2 release event --
        if Vector_Dist(EVENT.m2_down.pos, G.CONTROLLER.cursor_hover.T) >= 0.1 * G.MIN_CLICK_DIST then
            HANDLED.m2_drag = false
            EVENT.m2_drag.active = true
            EVENT.m2_drag.allowed = false
        end
    end

    -- If a Mouse2 release event hasn't been handled yet... --
    if not HANDLED.m2_up then
        -- First, stop dragging --
        EVENT.m2_drag.prev_target = nil
        EVENT.m2_drag.allowed = false
        EVENT.m2_drag.active = false
        HANDLED.m2_drag = true

        -- If Mouse2 press event was over a card and deselecting is enabled... --
        if EVENT.m2_down.target and MOD.config.deselect then
            if
                not EVENT.m2_down.target.click_timeout or
                EVENT.m2_down.target.click_timeout * G.SPEEDFACTOR > EVENT.m2_up.time - EVENT.m2_down.time
            then
                if EVENT.m2_down.target.states.click.can then
                    -- If the cursor release was in the same location as the cursor press... --
                    if Vector_Dist(EVENT.m2_down.pos, EVENT.m2_up.pos) < 0.1*G.MIN_CLICK_DIST then
                        -- ...register the release as an unhandled click (deselect) --
                        HANDLED.m2_click = false
                    end
                end
            end
        end
        -- Now, handle the cursor release --
        HANDLED.m2_up = true
    end

    -- If Mouse3 (Hold) to restart is disabled... --
    if not MOD.config.quick_restart then
        if not HANDLED.m3_down_event then
            if
                MOD.config.quick_menu and
                (not (G.CONTROLLER.locked) or G.SETTINGS.paused) and
                not G.CONTROLLER.locks.frame and
                not G.CONTROLLER.frame_buttonpress
            then
                G.CONTROLLER:key_press('escape')
            end
            HANDLED.m3_down_event = true
        end
        if not HANDLED.m3_up_event then
            HANDLED.m3_up_event = true
        end
    -- If Mouse3 (Hold) to restart is enabled
    else
        if not HANDLED.m3_down_event then
            G.CONTROLLER:key_press('r')
            HANDLED.m3_down_event = true
        end
        if not HANDLED.m3_up_event then
            if
                MOD.config.quick_menu and
                (not (G.CONTROLLER.locked) or G.SETTINGS.paused) and
                not G.CONTROLLER.locks.frame and
                not G.CONTROLLER.frame_buttonpress
            then
                if G.CONTROLLER.held_key_times['r'] and G.CONTROLLER.held_key_times['r'] <= 0.7 then
                    G.CONTROLLER:key_press('escape')
                end
            end
            G.CONTROLLER:key_release('r')
            HANDLED.m3_up_event = true
        end
    end

    ----Sending all input updates to the game objects----
    --unselect by clicking m2
    if not HANDLED.m2_click then
        if not G.SETTINGS.paused and G.hand and G.hand.highlighted[1] then 
            if (G.play and #G.play.cards > 0) or
                (G.CONTROLLER.locked) or 
                (G.CONTROLLER.locks.frame) or
                (G.GAMEVENT.STOP_USE and G.GAME.STOP_USE > 0) then return end
            G.hand:unhighlight_all()
        end   

        HANDLED.m2_click = true
    end
    
    --multiply select by dragging with m2
    if not HANDLED.m2_drag 
        and G.CONTROLLER.hovering.target 
        and G.CONTROLLER.hovering.target:is(Card) 
        and G.CONTROLLER.hovering.target.area == G.hand then
        if EVENT.m2_drag.active then
            --Was the gamepad button or Cursor is hoding
            if G.CONTROLLER.held_buttons['b'] then
                --Was the gamepad left or right button is hoding? If not, the thumbstick is moving
                if G.CONTROLLER.held_buttons['dpleft'] or G.CONTROLLER.held_buttons['dpright'] then
                    if G.CONTROLLER.hovering.prev_target:is(Card) then
                        G.CONTROLLER.hovering.prev_target:click()
                    end
                    G.CONTROLLER.hovering.target:click()
                else
                    G.CONTROLLER.hovering.target:click()
                end
            else
                G.CONTROLLER.hovering.target:click()
            end
            EVENT.m2_drag.active = false
        elseif G.CONTROLLER.hovering.prev_target ~= G.CONTROLLER.hovering.target then 
            if EVENT.m2_drag.prev_target == G.CONTROLLER.hovering.target then 
                if G.CONTROLLER.hovering.prev_target:is(Card) then
                    G.CONTROLLER.hovering.prev_target:click()
                end
        end
            G.CONTROLLER.hovering.target:click()
            EVENT.m2_drag.prev_target = G.CONTROLLER.hovering.prev_target
        end
    end
end
----------CONTROLLER UPDATE END-----------
------------------------------------------

----------------------------------------------
------------GAMEPAD BUTTON UPDATE-------------
function Controller:button_press_update(button, dt)
    if G.CONTROLLER.locks.frame then return end
    G.CONTROLLER.held_button_times[button] = 0
    G.CONTROLLER.interrupt.focus = false

    if not G.CONTROLLER:capture_focused_input(button, 'press', dt) then
        if button == 'dpup' then
            G.CONTROLLER:navigate_focus('U')
        end
        if button == 'dpdown' then
            G.CONTROLLER:navigate_focus('D')
        end
        if button == 'dpleft' then
            G.CONTROLLER:navigate_focus('L')
        end
        if button == 'dpright' then
            G.CONTROLLER:navigate_focus('R')
        end
    end

    if ((G.CONTROLLER.locked) and not G.SETTINGS.paused) or (G.CONTROLLER.locks.frame) or (G.CONTROLLER.frame_buttonpress) then return end
    G.CONTROLLER.frame_buttonpress = true

    if G.CONTROLLER.button_registry[button] and G.CONTROLLER.button_registry[button][1] and not G.CONTROLLER.button_registry[button][1].node.under_overlay then
        G.CONTROLLER.button_registry[button][1].click = true
    else
        if button == 'start' then
            if G.STATE == G.STATES.SPLASH then 
                G:delete_run()
                G:main_menu()
            end
        end
        if button == 'a' then
            if G.CONTROLLER.focused.target and
            G.CONTROLLER.focused.target.config.focus_args and
            G.CONTROLLER.focused.target.config.focus_args.type == 'slider' and 
            (not G.CONTROLLER.HID.mouse and not G.CONTROLLER.HID.axis_cursor) then 
            else
                G.CONTROLLER:L_cursor_press()
            end
        end
        --modification of this function start
        if button == 'b' then 
            if G.hand and G.CONTROLLER.focused.target and
            G.CONTROLLER.focused.target.area == G.hand and 
            MOD.config.b_click_or_hold then
                G.CONTROLLER:queue_R_cursor_press()
            else
                G.CONTROLLER.interrupt.focus = true
            end
        end
        if G.STATE == G.STATES.SELECTING_HAND then
            if button == 'leftshoulder' and MOD.config.left_shoulder_click then
                G.FUNCS.sort_hand_value()
            elseif button == 'rightshoulder' and MOD.config.right_shoulder_click then
                G.FUNCS.sort_hand_suit()
            end
        end
        if button == 'rightstick' and MOD.config.rightstick_click_or_hold then 
            queue_M_cursor_press()
        end
        --modification of this function end
    end
end

function Controller:button_hold_update(button, dt)
    --modification of this function start
    --enable hold multiple button
    --if ((self.locked) and not G.SETTINGS.paused) or (self.locks.frame) or (self.frame_buttonpress) then return end
    if ((G.CONTROLLER.locked) and not G.SETTINGS.paused) or (G.CONTROLLER.locks.frame) then return end
    --modification of this function end
    G.CONTROLLER.frame_buttonpress = true
    if G.CONTROLLER.held_button_times[button] then
        G.CONTROLLER.held_button_times[button] = G.CONTROLLER.held_button_times[button] + dt
        G.CONTROLLER:capture_focused_input(button, 'hold', dt)
    end
    if (button == 'dpleft' or button == 'dpright' or button == 'dpup' or button == 'dpdown') and not G.CONTROLLER.no_holdcap then
        G.CONTROLLER.repress_timer = G.CONTROLLER.repress_timer or 0.3
        if G.CONTROLLER.held_button_times[button] and (G.CONTROLLER.held_button_times[button] > G.CONTROLLER.repress_timer) then
            G.CONTROLLER.repress_timer = 0.1
            G.CONTROLLER.held_button_times[button] = 0
            G.CONTROLLER:button_press_update(button, dt)
        end
    end
end

local button_release_update_ref = Controller.button_release_update
function Controller.button_release_update(self, button, dt)
    button_release_update_ref(self, button, dt)

    --holding 'b' is same as holding m2
    if button == 'b' and MOD.config.b_click_or_hold then
        R_cursor_release()
    end

    if button == 'rightstick' and MOD.config.rightstick_click_or_hold then
        M_cursor_release()
    end
end
----------GAMEPAD BUTTON UPDATE END-----------
----------------------------------------------

------------------------------------------
------------PRESS AND RELEASE-------------
function Controller:queue_R_cursor_press(x, y)
    if G.CONTROLLER.locks.frame then return end
    --modification of this function start
    R_cursor_queue = {x = x, y = y}
    --modification of this function end
end

function queue_M_cursor_press()
    if G.CONTROLLER.locks.frame then return end
    M_cursor_queue = {}
end

function queue_m4_cursor_press()
    if G.CONTROLLER.locks.frame or not MOD.config.quick_sort_suit then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND then 
        G.FUNCS.sort_hand_suit()
    end
end

function queue_m5_cursor_press()
    if G.CONTROLLER.locks.frame or not MOD.config.quick_sort_value then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND then 
        G.FUNCS.sort_hand_value()
    end
end

function queue_U_wheel_press()
    if G.CONTROLLER.locks.frame or not MOD.config.quick_play then return end
    if G.CONTROLLER.cursor_down.target and G.CONTROLLER.cursor_down.target.states.drag.is then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND and STATE.selecting_hand then
        local play_button = G.buttons:get_UIE_by_ID('play_button')
        if play_button and play_button.config.button then
            G.FUNCS.play_cards_from_highlighted()
            STATE.selecting_hand = false
        end
    end
end

function queue_D_wheel_press()
    if G.CONTROLLER.locks.frame or not MOD.config.quick_discard then return end
    if G.CONTROLLER.cursor_down.target and G.CONTROLLER.cursor_down.target.states.drag.is then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND and STATE.selecting_hand then
        local discard_button = G.buttons:get_UIE_by_ID('discard_button')
        if discard_button and discard_button.config.button then
            G.FUNCS.discard_cards_from_highlighted()
            STATE.selecting_hand = false
        end
    end
end

function R_cursor_press(x, y)
    x = x or G.CONTROLLER.cursor_position.x
    y = y or G.CONTROLLER.cursor_position.y

    if ((G.CONTROLLER.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (G.CONTROLLER.locks.frame) then return end

    EVENT.m2_down.pos = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    EVENT.m2_down.time = G.TIMERS.TOTAL
    HANDLED.m2_down = false
    EVENT.m2_down.target = nil

    local press_node =  (G.CONTROLLER.HID.touch and G.CONTROLLER.cursor_hover.target) or G.CONTROLLER.hovering.target or G.CONTROLLER.focused.target

    if press_node then
        EVENT.m2_down.target = press_node.states.click.can and press_node or press_node:can_drag() or nil
    end

    if EVENT.m2_down.target == nil then 
        EVENT.m2_down.target = G.ROOM
    end
end

function R_cursor_release(x, y)
    x = x or G.CONTROLLER.cursor_position.x
    y = y or G.CONTROLLER.cursor_position.y

    if ((G.CONTROLLER.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (G.CONTROLLER.locks.frame) then return end

    EVENT.m2_up.pos = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    EVENT.m2_up.time = G.TIMERS.TOTAL
    HANDLED.m2_up = false
    EVENT.m2_up.target = nil

    EVENT.m2_up.target = G.CONTROLLER.hovering.target or G.CONTROLLER.focused.target

    if EVENT.m2_up.target == nil then
        EVENT.m2_up.target = G.ROOM
    end
end

function M_cursor_press()
    HANDLED.m3_down_event = false
end

function M_cursor_release()
    HANDLED.m3_up_event = false
end

----------PRESS AND RELEASE END-----------
------------------------------------------

--- Config menu tabs ---
------------------------

--- Features tab ---
function cfg_features_tab()
    return {
        n = G.UIT.ROOT,
        config = cfg_tab_layout,
        nodes = {
            create_toggle({
                label = localize('deselect'),
                ref_table = MOD.config,
                ref_value = 'deselect'
            }),
            create_toggle({
                label = localize('multiselect'),
                ref_table = MOD.config,
                ref_value = 'multiselect'
            }),
            create_toggle({
                label = localize('quick_menu'),
                ref_table = MOD.config,
                ref_value = 'quick_menu'
            }),
            create_toggle({
                label = localize('quick_restart'),
                ref_table = MOD.config,
                ref_value = 'quick_restart'
            }),
            create_toggle({
                label = localize('quick_play'),
                ref_table = MOD.config,
                ref_value = 'quick_play'
            }),
            create_toggle({
                label = localize('quick_discard'),
                ref_table = MOD.config,
                ref_value = 'quick_discard'
            }),
            create_toggle({
                label = localize('quick_sort_suit'),
                ref_table = MOD.config,
                ref_value = 'quick_sort_suit'
            }),
            create_toggle({
                label = localize('quick_sort_value'),
                ref_table = MOD.config,
                ref_value = 'quick_sort_value'
            }),
        }
    }
end

--- Modifiers tab ---
function cfg_modifiers_tab()
    return {
        n = G.UIT.ROOT,
        config = cfg_tab_layout,
        nodes = {
            create_toggle({
                label = localize('swap_m_wheel_up_with_down'),
                ref_table = MOD.config,
                ref_value = 'swap_m_wheel_up_with_down'
            }),
            create_toggle({
                label = localize('swap_m4_with_m5'),
                ref_table = MOD.config,
                ref_value = 'swap_m4_with_m5'
            }),
            create_toggle({
                label = localize('swap_m_wheel_with_m4_and_m5'),
                ref_table = MOD.config,
                ref_value = 'swap_m_wheel_with_m4_and_m5'
            }),
        }
    }
end

--- Gamepad tab ---
function cfg_gamepad_tab()
    return {
        n = G.UIT.ROOT,
        config = cfg_tab_layout,
        nodes = {
            create_toggle({
                label = localize('b_click_or_hold'),
                ref_table = MOD.config,
                ref_value = 'b_click_or_hold',
                info = localize('b_click_or_hold_info')
            }),
            create_toggle({
                label = localize('rightstick_click_or_hold'),
                ref_table = MOD.config,
                ref_value = 'rightstick_click_or_hold',
                info = localize('rightstick_click_or_hold_info')
            }),
            create_toggle({
                label = localize('left_shoulder_click'),
                ref_table = MOD.config,
                ref_value = 'left_shoulder_click'
            }),
            create_toggle({
                label = localize('right_shoulder_click'),
                ref_table = MOD.config,
                ref_value = 'right_shoulder_click'
            }),
            create_toggle({
                label = localize('swap_a_with_b'),
                ref_table = MOD.config,
                ref_value = 'swap_a_with_b'
            }),
        }
    }
end

--- Help tab ---
function cfg_help_tab()
    return {
        n = G.UIT.ROOT, 
        config = cfg_tab_layout, 
        nodes = {
            {
                n = G.UIT.T, 
                config = {
                    text = localize('help'),
                    scale = 0.4,
                    colour = G.C.UI.TEXT_LIGHT
                }
            },
        }
    }
end

cfg_tab_layout = {
    align = 'tm',
    r = 0.1,
    padding = 0.3,
    outline = 1,
    colour = G.C.BLACK,
    minh = 8,
    maxw = 16
}

--- Set config tabs
MOD.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = {
            r = 0.1,
            minw = 10,
            align = 'cm',
            padding = 0.1,
            colour = G.C.BLACK
        },
        nodes = {
            create_tabs({
                tabs = {
                    {
                        label = localize('tabs_features'),
                        chosen = true,
                        tab_definition_function = cfg_features_tab,
                    },
                    {
                        label = localize('tabs_modifiers'),
                        tab_definition_function = cfg_modifiers_tab,
                    },
                    {
                        label = localize('tabs_gamepad'),
                        tab_definition_function = cfg_gamepad_tab,
                    },
                    {
                        label = localize('tabs_help'),
                        tab_definition_function = cfg_help_tab,
                    },
                }
            })
        }
    }
end

----------------------------
--- Config menu tabs END ---

----------------------------------------------
------------MOD CODE END----------------------
