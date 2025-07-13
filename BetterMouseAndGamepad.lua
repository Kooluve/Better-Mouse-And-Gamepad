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
E = {
    m2_click = {
        target = nil,
        handled = true,
        prev_target = nil
    },
    m2_drag = {
        target = nil,
        handled = true,
        prev_target = nil,
        start = false,
        can = false
    },
    m2_down = {
        T = {
            x=0,
            y=0
        },
        target = nil,
        time = 0,
        handled = true
    },
    m2_up = {
        T = {
            x=0,
            y=0
        },
        target = nil,
        time = 0.1,
        handled = true
    },
}

-- Input handling flags --
H = {
    m3_click = true,
    m3_down_event = true,
    m3_up_event = true,
}

-- Game state data --
S = {
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
        if button == 'a' then button = 'b'
        elseif button == 'b' then button = 'a'
        end
    end

	C:set_gamepad(joystick)
    C:set_HID_flags('button', button)
    C:button_press(button)
end

-- Gamepad button release event remapping --
function love.gamepadreleased(joystick, button)
	button = G.button_mapping[button] or button
    button = MOD.config.gamepad_map[button] or button

    -- handle A/B swap if enabled
    if MOD.config.swap_a_with_b then
        if button == 'a' then button = 'b'
        elseif button == 'b' then button = 'a'
        end
    end

    C:set_gamepad(joystick)
    C:set_HID_flags('button', button)
    C:button_release(button)
end

-- Mouse button press event remapping --
function love.mousepressed(x, y, button, touch)
    C:set_HID_flags(touch and 'touch' or 'mouse')

    if MOD.config.mouse_map[button] == 'm1' then 
        C:queue_L_cursor_press(x, y)
    elseif MOD.config.mouse_map[button] == 'm2' then 
        C:queue_R_cursor_press(x, y)
    elseif MOD.config.mouse_map[button] == 'm3' then 
		queue_M_cursor_press()
	end

    local is_m4 = MOD.config.mouse_map[button] == 'm4'
    local is_m5 = MOD.config.mouse_map[button] == 'm5'
    local swapped = MOD.config.swap_m4_with_m5
    local wheel_swapped = MOD.config.swap_m_wheel_with_m4_and_m5

    if (is_m4 and not swapped) or (is_m5 and swapped) then
        if not wheel_swapped then
            queue_m4_cursor_press()
        else
            queue_D_wheel_press()
        end
    elseif (is_m5 and not swapped) or (is_m4 and swapped) then
        if not wheel_swapped then
            queue_m5_cursor_press()
        else
            queue_U_wheel_press()
        end
    end
end

-- Mouse button release event remapping --
function love.mousereleased(x, y, button)
    if MOD.config.mouse_map[button] == 'm1' then C:L_cursor_release(x, y) end
    if MOD.config.mouse_map[button] == 'm2' then R_cursor_release(x, y) end
	if MOD.config.mouse_map[button] == 'm3' then M_cursor_release(x, y) end
end

-- Mouse wheel movement event remapping --
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

------------------------------------------
------------CONTROLLER UPDATE-------------
local update_ref = Controller.update
function Controller.update(self, dt)
    update_ref(self, dt)

    if S.last ~= G.STATES.SELECTING_HAND and G.STATE == G.STATES.SELECTING_HAND then
        S.selecting_hand = true
    end
    if S.last == G.STATES.SELECTING_HAND and G.STATE ~= G.STATES.SELECTING_HAND then
        S.selecting_hand = false
    end
    S.last = G.STATE

    if R_cursor_queue then 
        R_cursor_press(R_cursor_queue.x, R_cursor_queue.y)
        R_cursor_queue = nil
    end

    if M_cursor_queue then 
        M_cursor_press()
        M_cursor_queue = nil
    end

    --m2
    if not E.m2_down.handled then
        if MOD.config.m2_hold then
            E.m2_drag.can = true
        end
        E.m2_down.handled = true
    end
    if E.m2_drag.can
        and not E.m2_drag.start 
        and E.m2_drag.handled 
        and E.m2_click.handled 
        and E.m2_down.target then
        --Was the Cursor release in the same location as the Cursor press?
        if Vector_Dist(E.m2_down.T, C.cursor_hover.T) >= 0.1*G.MIN_CLICK_DIST then 
            E.m2_drag.handled = false
            E.m2_drag.start = true
            E.m2_drag.can = false
        end
    end
    if not E.m2_up.handled then 
        --First, stop dragging
        E.m2_drag.prev_target = nil
        E.m2_drag.handled = true
        E.m2_drag.can = false
        E.m2_drag.start = false  
        --Now, handle the Cursor release
        --Was the Cursor release in the same location as the Cursor press?
        if E.m2_down.target and MOD.config.m2_click then 
            if (not E.m2_down.target.click_timeout or E.m2_down.target.click_timeout*G.SPEEDFACTOR > E.m2_up.time - E.m2_down.time) then
                if E.m2_down.target.states.click.can then
                    if Vector_Dist(E.m2_down.T, E.m2_up.T) < 0.1*G.MIN_CLICK_DIST then 
                        E.m2_click.handled = false
                    end
                end
            end
        end
        E.m2_up.handled = true
    end

    --m3
    if not MOD.config.m3_hold and MOD.config.m3_click then
        if not H.m3_down_event then
            if ((C.locked) and not G.SETTINGS.paused) or (C.locks.frame) or (C.frame_buttonpress) then
            else
                H.m3_click = false
            end
            H.m3_down_event = true
        end
        if not H.m3_up_event then
            H.m3_up_event = true
        end
    else
        if not H.m3_down_event then
            if MOD.config.m3_hold or MOD.config.m3_click then
                C:key_press('r')
            end
            H.m3_down_event = true
        end
        if not H.m3_up_event then
            if not MOD.config.m3_click or ((C.locked) and not G.SETTINGS.paused) or (C.locks.frame) or (C.frame_buttonpress) then
            else
                if C.held_key_times['r'] and C.held_key_times['r'] <= 0.7 then
                    H.m3_click = false
                end
            end
            if MOD.config.m3_hold or MOD.config.m3_click then
                C:key_release('r')
            end
            H.m3_up_event = true
        end
    end

    ----Sending all input updates to the game objects----
    --unselect by clicking m2
    if not E.m2_click.handled then
        if not G.SETTINGS.paused and G.hand and G.hand.highlighted[1] then 
            if (G.play and #G.play.cards > 0) or
                (C.locked) or 
                (C.locks.frame) or
                (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then return end
            G.hand:unhighlight_all()
        end   

        E.m2_click.handled = true
    end
    
    --multiply select by dragging with m2
    if not E.m2_drag.handled 
        and C.hovering.target 
        and C.hovering.target:is(Card) 
        and C.hovering.target.area == G.hand then
        if E.m2_drag.start then
            --Was the gamepad button or Cursor is hoding
            if C.held_buttons['b'] then
                --Was the gamepad left or right button is hoding? If not, the thumbstick is moving
                if C.held_buttons['dpleft'] or C.held_buttons['dpright'] then
                    if C.hovering.prev_target:is(Card) then
                        C.hovering.prev_target:click()
                    end
                    C.hovering.target:click()
                else
                    C.hovering.target:click()
                end
            else
                C.hovering.target:click()
            end
            E.m2_drag.start = false
        elseif C.hovering.prev_target ~= C.hovering.target then 
            if E.m2_drag.prev_target == C.hovering.target then 
                if C.hovering.prev_target:is(Card) then
                    C.hovering.prev_target:click()
                end
        end
            C.hovering.target:click()
            E.m2_drag.prev_target = C.hovering.prev_target
        end
    end

    --escape by clicking m3
    if not H.m3_click then
        C:key_press('escape')
        H.m3_click = true
    end
end
----------CONTROLLER UPDATE END-----------
------------------------------------------

----------------------------------------------
------------GAMEPAD BUTTON UPDATE-------------
function Controller:button_press_update(button, dt)
    if C.locks.frame then return end
    C.held_button_times[button] = 0
    C.interrupt.focus = false

    if not C:capture_focused_input(button, 'press', dt) then
        if button == 'dpup' then
            C:navigate_focus('U')
        end
        if button == 'dpdown' then
            C:navigate_focus('D')
        end
        if button == 'dpleft' then
            C:navigate_focus('L')
        end
        if button == 'dpright' then
            C:navigate_focus('R')
        end
    end

    if ((C.locked) and not G.SETTINGS.paused) or (C.locks.frame) or (C.frame_buttonpress) then return end
    C.frame_buttonpress = true

    if C.button_registry[button] and C.button_registry[button][1] and not C.button_registry[button][1].node.under_overlay then
        C.button_registry[button][1].click = true
    else
        if button == 'start' then
            if G.STATE == G.STATES.SPLASH then 
                G:delete_run()
                G:main_menu()
            end
        end
        if button == 'a' then
            if C.focused.target and
            C.focused.target.config.focus_args and
            C.focused.target.config.focus_args.type == 'slider' and 
            (not C.HID.mouse and not C.HID.axis_cursor) then 
            else
                C:L_cursor_press()
            end
        end
        --modification of this function start
        if button == 'b' then 
            if G.hand and C.focused.target and
            C.focused.target.area == G.hand and 
            MOD.config.b_click_or_hold then
                C:queue_R_cursor_press()
            else
                C.interrupt.focus = true
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
    if ((C.locked) and not G.SETTINGS.paused) or (C.locks.frame) then return end
    --modification of this function end
    C.frame_buttonpress = true
    if C.held_button_times[button] then
        C.held_button_times[button] = C.held_button_times[button] + dt
        C:capture_focused_input(button, 'hold', dt)
    end
    if (button == 'dpleft' or button == 'dpright' or button == 'dpup' or button == 'dpdown') and not C.no_holdcap then
        C.repress_timer = C.repress_timer or 0.3
        if C.held_button_times[button] and (C.held_button_times[button] > C.repress_timer) then
            C.repress_timer = 0.1
            C.held_button_times[button] = 0
            C:button_press_update(button, dt)
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
    if C.locks.frame then return end
    --modification of this function start
    R_cursor_queue = {x = x, y = y}
    --modification of this function end
end

function queue_M_cursor_press()
    if C.locks.frame then return end
    M_cursor_queue = {}
end

function queue_m4_cursor_press()
    if C.locks.frame or not MOD.config.m4_click then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND then 
        G.FUNCS.sort_hand_suit()
    end
end

function queue_m5_cursor_press()
    if C.locks.frame or not MOD.config.m5_click then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND then 
        G.FUNCS.sort_hand_value()
    end
end

function queue_U_wheel_press()
    if C.locks.frame or not MOD.config.m_wheel_up then return end
    if C.cursor_down.target and C.cursor_down.target.states.drag.is then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND and S.selecting_hand then
        local play_button = G.buttons:get_UIE_by_ID('play_button')
        if play_button and play_button.config.button then
            G.FUNCS.play_cards_from_highlighted()
            S.selecting_hand = false
        end
    end
end

function queue_D_wheel_press()
    if C.locks.frame or not MOD.config.m_wheel_down then return end
    if C.cursor_down.target and C.cursor_down.target.states.drag.is then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND and S.selecting_hand then
        local discard_button = G.buttons:get_UIE_by_ID('discard_button')
        if discard_button and discard_button.config.button then
            G.FUNCS.discard_cards_from_highlighted()
            S.selecting_hand = false
        end
    end
end

function R_cursor_press(x, y)
    x = x or C.cursor_position.x
    y = y or C.cursor_position.y

    if ((C.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (C.locks.frame) then return end

    E.m2_down.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    E.m2_down.time = G.TIMERS.TOTAL
    E.m2_down.handled = false
    E.m2_down.target = nil

    local press_node =  (C.HID.touch and C.cursor_hover.target) or C.hovering.target or C.focused.target

    if press_node then 
        E.m2_down.target = press_node.states.click.can and press_node or press_node:can_drag() or nil
    end

    if E.m2_down.target == nil then 
        E.m2_down.target = G.ROOM
    end
end

function R_cursor_release(x, y)
    x = x or C.cursor_position.x
    y = y or C.cursor_position.y

    if ((C.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (C.locks.frame) then return end

    E.m2_up.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    E.m2_up.time = G.TIMERS.TOTAL
    E.m2_up.handled = false
    E.m2_up.target = nil

    E.m2_up.target = C.hovering.target or C.focused.target

    if E.m2_up.target == nil then 
        E.m2_up.target = G.ROOM
    end
end

function M_cursor_press()
    H.m3_down_event = false
end

function M_cursor_release()
    H.m3_up_event = false
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
                label = localize('m2_click'),
                ref_table = MOD.config,
                ref_value = 'm2_click'
            }),
            create_toggle({
                label = localize('m2_hold'), 
                ref_table = MOD.config, 
                ref_value = 'm2_hold'
            }),
            create_toggle({
                label = localize('m3_click'),
                ref_table = MOD.config,
                ref_value = 'm3_click'
            }),
            create_toggle({
                label = localize('m3_hold'),
                ref_table = MOD.config,
                ref_value = 'm3_hold'
            }),
            create_toggle({
                label = localize('m_wheel_up'),
                ref_table = MOD.config,
                ref_value = 'm_wheel_up'
            }),
            create_toggle({
                label = localize('m_wheel_down'),
                ref_table = MOD.config,
                ref_value = 'm_wheel_down'
            }),
            create_toggle({
                label = localize('m4_click'),
                ref_table = MOD.config,
                ref_value = 'm4_click'
            }),
            create_toggle({
                label = localize('m5_click'),
                ref_table = MOD.config,
                ref_value = 'm5_click'
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
