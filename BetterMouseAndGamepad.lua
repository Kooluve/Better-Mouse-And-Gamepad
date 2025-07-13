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
CONTROLLER = G.CONTROLLER

-- Mouse button press event override --
function love.mousepressed(x, y, button, touch)
    CONTROLLER:set_HID_flags(touch and 'touch' or 'mouse')

    if MOD.config.mouse_map[button] == 'm1' then
        CONTROLLER:queue_L_cursor_press(x, y)
    elseif MOD.config.mouse_map[button] == 'm2' then
        CONTROLLER:m2_press(x, y)
    elseif
        MOD.config.mouse_map[button] == 'm3' and
        not CONTROLLER.locks.frame
    then
        HANDLED.m3_down_event = false
    elseif MOD.config.mouse_map[button] == 'm4' then
        if MOD.config.swap_m_wheel_with_m4_and_m5 then
            if MOD.config.swap_m4_with_m5 then
                CONTROLLER:wheel_up()
            else
                CONTROLLER:wheel_down()
            end
        elseif MOD.config.swap_m4_with_m5 then
            CONTROLLER:m5_press()
        else
            CONTROLLER:m4_press()
        end
    elseif MOD.config.mouse_map[button] == 'm5' then
        if MOD.config.swap_m_wheel_with_m4_and_m5 then
            if MOD.config.swap_m4_with_m5 then
                CONTROLLER:wheel_down()
            else
                CONTROLLER:wheel_up()
            end
        elseif MOD.config.swap_m4_with_m5 then
            CONTROLLER:m4_press()
        else
            CONTROLLER:m5_press()
        end
    end
end

-- Mouse button release event override --
function love.mousereleased(x, y, button)
    if MOD.config.mouse_map[button] == 'm1' then
        CONTROLLER:L_cursor_release(x, y)
    elseif MOD.config.mouse_map[button] == 'm2' then
        CONTROLLER:m2_release(x, y)
    elseif 
        MOD.config.mouse_map[button] == 'm3' and
        not CONTROLLER.locks.frame
    then
        HANDLED.m3_up_event = false
    end
    -- m4 / m5 press events are instantaneous; don't need release calls --
end

-- Mouse wheel movement event override --
function love.wheelmoved(x, y)
    if MOD.config.swap_m_wheel_up_with_down then y = -y end
    if y > 0 then
        if not MOD.config.swap_m_wheel_with_m4_and_m5 then
		    CONTROLLER:wheel_up()
        else
            CONTROLLER:m5_press()
        end
    end
    if y < 0 then
        if not MOD.config.swap_m_wheel_with_m4_and_m5 then
		    CONTROLLER:wheel_down()
        else
            CONTROLLER:m4_press()
        end
    end
end

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

	CONTROLLER:set_gamepad(joystick)
    CONTROLLER:set_HID_flags('button', button)
    CONTROLLER:button_press(button)
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

    CONTROLLER:set_gamepad(joystick)
    CONTROLLER:set_HID_flags('button', button)
    CONTROLLER:button_release(button)
end

----------------------------
-- Controller Parse Loops --
----------------------------

local c_update_old = Controller.update

-- Control parsing loop --
function Controller:update(dt)
    c_update_old(self, dt)

    -- Determine if player is currently selecting a hand --
    if
        STATE.last ~= G.STATES.SELECTING_HAND and
        G.STATE == G.STATES.SELECTING_HAND
    then
        STATE.selecting_hand = true
    elseif
        STATE.last == G.STATES.SELECTING_HAND and
        G.STATE ~= G.STATES.SELECTING_HAND
    then
        STATE.selecting_hand = false
    end

    -- Update stored game state --
    STATE.last = G.STATE

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
        if Vector_Dist(EVENT.m2_down.pos, self.cursor_hover.T) >= 0.1 * G.MIN_CLICK_DIST then
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
                (not (self.locked) or G.SETTINGS.paused) and
                not self.locks.frame and
                not self.frame_buttonpress
            then
                self:key_press('escape')
            end
            HANDLED.m3_down_event = true
        end
        if not HANDLED.m3_up_event then
            HANDLED.m3_up_event = true
        end
    -- If Mouse3 (Hold) to restart is enabled
    else
        if not HANDLED.m3_down_event then
            self:key_press('r')
            HANDLED.m3_down_event = true
        end
        if not HANDLED.m3_up_event then
            if
                MOD.config.quick_menu and
                (not (self.locked) or G.SETTINGS.paused) and
                not self.locks.frame and
                not self.frame_buttonpress
            then
                if
                    self.held_key_times['r'] and
                    self.held_key_times['r'] <= 0.7
                then
                    self:key_press('escape')
                end
            end
            self:key_release('r')
            HANDLED.m3_up_event = true
        end
    end

    -- Mouse2 (Click) to deselect --
    if not HANDLED.m2_click then
        if
            not G.SETTINGS.paused and
            G.hand and
            G.hand.highlighted[1]
        then
            if
                (G.play and #G.play.cards > 0) or
                self.locked or
                self.locks.frame or
                (G.GAMEVENT.STOP_USE and G.GAME.STOP_USE > 0)
            then
                return
            end
            G.hand:unhighlight_all()
        end
        HANDLED.m2_click = true
    end

    -- Mouse2 (Hold/Drag) to select multiple cards --
    if
        not HANDLED.m2_drag
        and self.hovering.target
        and self.hovering.target:is(Card)
        and self.hovering.target.area == G.hand
    then
        if EVENT.m2_drag.active then
            -- Gamepad multiselect --
            if self.held_buttons['b'] then
                if
                    self.held_buttons['dpleft'] or
                    self.held_buttons['dpright']
                then
                    if self.hovering.prev_target:is(Card) then
                        self.hovering.prev_target:click()
                    end
                    self.hovering.target:click()
                else
                    self.hovering.target:click()
                end
            -- Mouse multiselect --
            else
                self.hovering.target:click()
            end
            EVENT.m2_drag.active = false
        -- Begin a new drag event --
        elseif
            self.hovering.prev_target ~= self.hovering.target
        then
            if
                EVENT.m2_drag.prev_target == self.hovering.target and
                self.hovering.prev_target:is(Card)
            then
                self.hovering.prev_target:click()
            end
            self.hovering.target:click()
            EVENT.m2_drag.prev_target = self.hovering.prev_target
        end
    end
end

----------------------------
-- Gamepad Event Handlers --
----------------------------

-- Gamepad button press event handler --
function Controller:button_press_update(button, dt)
    if
        (self.locked and not G.SETTINGS.paused) or
        self.locks.frame or
        self.frame_buttonpress
    then
        return
    end

    self.held_button_times[button] = 0
    self.interrupt.focus = false
    self.frame_buttonpress = true

    if not self:capture_focused_input(button, 'press', dt) then
        if button == 'dpup' then
            self:navigate_focus('U')
        elseif button == 'dpdown' then
            self:navigate_focus('D')
        elseif button == 'dpleft' then
            self:navigate_focus('L')
        elseif button == 'dpright' then
            self:navigate_focus('R')
        end
    end

    if
        self.button_registry[button] and
        self.button_registry[button][1] and
        not self.button_registry[button][1].node.under_overlay
    then
        self.button_registry[button][1].click = true
    elseif
        button == 'start' and
        G.STATE == G.STATES.SPLASH
    then
        G:delete_run()
        G:main_menu()
    elseif
        button == 'a' and
        not (
            self.focused.target and
            self.focused.target.config.focus_args and
            self.focused.target.config.focus_args.type == 'slider' and
            not (self.HID.mouse or self.HID.axis_cursor)
        )
    then
        self:L_cursor_press()
    elseif button == 'b' then
        if
            G.hand and
            self.focused.target and
            self.focused.target.area == G.hand and
            MOD.config.b_click_or_hold
        then
            self:m2_press(self.cursor_position.x, self.cursor_position.y)
        else
            self.interrupt.focus = true
        end
    elseif G.STATE == G.STATES.SELECTING_HAND then
        if
            button == 'leftshoulder' and
            MOD.config.left_shoulder_click
        then
            G.FUNCS.sort_hand_value()
        elseif
            button == 'rightshoulder' and
            MOD.config.right_shoulder_click
        then
            G.FUNCS.sort_hand_suit()
        end
    elseif
        button == 'rightstick' and
        MOD.config.rightstick_click_or_hold
    then
        HANDLED.m3_down_event = false
    end
end

-- Gamepad button hold event handler --
function Controller:button_hold_update(button, dt)
    if
        (self.locked and not G.SETTINGS.paused) or
        self.locks.frame
    then
        return
    end

    self.frame_buttonpress = true
    if self.held_button_times[button] then
        self.held_button_times[button] = self.held_button_times[button] + dt
        self:capture_focused_input(button, 'hold', dt)
    end
    if
        (button == 'dpleft' or button == 'dpright' or button == 'dpup' or button == 'dpdown') and
        not self.no_holdcap
    then
        self.repress_timer = self.repress_timer or 0.3
        if
            self.held_button_times[button] and
            self.held_button_times[button] > self.repress_timer
        then
            self.repress_timer = 0.1
            self.held_button_times[button] = 0
            self:button_press_update(button, dt)
        end
    end
end

local old_button_release_update = Controller.button_release_update

-- Gamepad button release event handler --
function Controller:button_release_update(button, dt)
    old_button_release_update(self, button, dt)

    if
        button == 'b' and
        MOD.config.b_click_or_hold
    then
        self:m2_release()
    end

    if
        button == 'rightstick' and
        MOD.config.rightstick_click_or_hold
    then
        HANDLED.m3_up_event = false
    end
end

--------------------------
-- Mouse Event Handlers --
--------------------------

-- Mouse 2 Press event handler
function Controller:m2_press(x, y)
    x = x or self.cursor_position.x
    y = y or self.cursor_position.y

    if
        (self.locked and (not G.SETTINGS.paused or G.screenwipe)) or
        (self.locks.frame)
    then
        return
    end

    EVENT.m2_down.target = nil
    EVENT.m2_down.pos = {
        x = x / (G.TILESCALE * G.TILESIZE),
        y = y / (G.TILESCALE * G.TILESIZE),
    }
    EVENT.m2_down.time = G.TIMERS.TOTAL
    HANDLED.m2_down = false

    local press_node = 
        (self.HID.touch and self.cursor_hover.target) or
        self.hovering.target or
        self.focused.target

    if press_node then
        EVENT.m2_down.target = press_node.states.click.can and press_node or press_node:can_drag() or nil
    end

    if EVENT.m2_down.target == nil then
        EVENT.m2_down.target = G.ROOM
    end
end

-- Mouse 2 Release event handler
function Controller:m2_release(x, y)
    x = x or self.cursor_position.x
    y = y or self.cursor_position.y

    if
        (self.locked and (not G.SETTINGS.paused or G.screenwipe)) or
        (self.locks.frame)
    then
        return
    end

    EVENT.m2_up.target = nil
    EVENT.m2_up.pos = {
        x = x / (G.TILESCALE * G.TILESIZE),
        y = y / (G.TILESCALE * G.TILESIZE),
    }
    EVENT.m2_up.time = G.TIMERS.TOTAL
    HANDLED.m2_up = false

    EVENT.m2_up.target =
        self.hovering.target or
        self.focused.target

    if EVENT.m2_up.target == nil then
        EVENT.m2_up.target = G.ROOM
    end
end

-- Mouse4 Press event handler --
function Controller:m4_press()
    if
        self.locks.frame or
        not MOD.config.quick_sort_suit
    then
        return
    end

    if
        not G.SETTINGS.paused and
        G.STATE == G.STATES.SELECTING_HAND
    then
        G.FUNCS.sort_hand_suit()
    end
end

-- Mouse5 Press event handler --
function Controller:m5_press()
    if
        self.locks.frame or
        not MOD.config.quick_sort_value
    then
        return
    end

    if
        not G.SETTINGS.paused and
        G.STATE == G.STATES.SELECTING_HAND
    then
        G.FUNCS.sort_hand_value()
    end
end

-- Mouse Wheel Up event handler --
function Controller:wheel_up()
    if
        self.locks.frame or
        not MOD.config.quick_play
    then
        return
    end

    if
        self.cursor_down.target and
        self.cursor_down.target.states.drag.is
    then
        return
    end

    if
        not G.SETTINGS.paused and
        G.STATE == G.STATES.SELECTING_HAND and
        STATE.selecting_hand
    then
        local play_button = G.buttons:get_UIE_by_ID('play_button')
        if play_button and play_button.config.button then
            G.FUNCS.play_cards_from_highlighted()
            STATE.selecting_hand = false
        end
    end
end

-- Mouse Wheel Down event handler --
function Controller:wheel_down()
    if
        self.locks.frame or
        not MOD.config.quick_discard
    then
        return
    end

    if
        self.cursor_down.target and
        self.cursor_down.target.states.drag.is
    then
        return
    end

    if
        not G.SETTINGS.paused and
        G.STATE == G.STATES.SELECTING_HAND and
        STATE.selecting_hand
    then
        local discard_button = G.buttons:get_UIE_by_ID('discard_button')
        if discard_button and discard_button.config.button then
            G.FUNCS.discard_cards_from_highlighted()
            STATE.selecting_hand = false
        end
    end
end

-------------------
--- Config menu ---
-------------------

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
