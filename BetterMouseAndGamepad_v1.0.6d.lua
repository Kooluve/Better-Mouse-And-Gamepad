--- STEAMODDED HEADER
--- MOD_NAME: Better Mouse And Gamepad
--- MOD_ID: BetterMouseAndGamepad
--- MOD_AUTHOR: [Kooluve]
--- MOD_DESCRIPTION: Make mouse and gamepad more efficient and easier to use, effectively relieve finger pressure. I guess this maybe one of the most useful mods ;)
--- PRIORITY: -10000
--- PREFIX: bmag_k
--- VERSION: 1.0.6c

----------------------------------------------
------------MOD CODE -------------------------
-------------------------------------
------------EXTRA SETTINGS------------
--in general, you don't need to change the following settings, be careful when making modifications
--exchange the number with other existing number left to '=' to modify mouse button mapping
mouse_button_mapping = {
    [1] = 'left_mouse_button',
    [2] = 'right_mouse_button',
    [3] = 'middle_mouse_button',
    [4] = 'x1',
    [5] = 'x2',
}

--in general, you don't need to change the following settings, be careful when making modifications
--exchange the string with other existing string left to '=' to modify mouse button mapping
gpad_button_mapping = {
    ['a'] = 'a',
    ['b'] = 'b',
    ['x'] = 'x',
    ['y'] = 'y',
    ['leftshoulder'] = 'leftshoulder',
    ['rightshoulder'] = 'rightshoulder',
    ['back'] = 'back',
    ['start'] = 'start',
    ['dpleft'] = 'dpleft',
    ['dpright'] = 'dpright',
    ['dpup'] = 'dpup',
    ['dpdown'] = 'dpdown',
    ['leftstick'] = 'leftstick', --no function in original game
    ['rightstick'] = 'rightstick', --no function in original game
    -- can't map trigger to other button, reason unknown, maybe need to modify ui functions
    -- ['triggerleft'] = 'triggerleft',
    -- ['triggerright'] = 'triggerright',
}
-------------------------------------
-----------EXTRA SETTING END----------

-----------------------------------
------------CONFIG MENU------------
BMAG = SMODS.current_mod

tab_content_config = {align = 'tm', r = 0.1, padding = 0.3, outline = 1, colour = G.C.BLACK, minh = 8, maxw = 16}

BMAG.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 10, align = 'cm', padding = 0.1, colour = G.C.BLACK}, nodes = {
        create_tabs({
            tabs = {
                {
                    label = localize('tabs_mouse_page_1'),
                    chosen = true,
                    tab_definition_function = function() return {n = G.UIT.ROOT, config = tab_content_config, nodes={
                        {
                            n = G.UIT.R, config = {align = 'rm'}, nodes={
                                create_toggle({label = localize('right_mouse_button_click'), ref_table = BMAG.config, ref_value = 'right_mouse_button_click'}),
                                create_toggle({label = localize('right_mouse_button_hold'), ref_table = BMAG.config, ref_value = 'right_mouse_button_hold'}),
                                create_toggle({label = localize('middle_mouse_button_click'), ref_table = BMAG.config, ref_value = 'middle_mouse_button_click'}),
                                create_toggle({label = localize('middle_mouse_button_hold'), ref_table = BMAG.config, ref_value = 'middle_mouse_button_hold'}),
                                create_toggle({label = localize('middle_mouse_button_up'), ref_table = BMAG.config, ref_value = 'middle_mouse_button_up'}),
                                create_toggle({label = localize('middle_mouse_button_down'), ref_table = BMAG.config, ref_value = 'middle_mouse_button_down'}),
                                create_toggle({label = localize('x1_click'), ref_table = BMAG.config, ref_value = 'x1_click'}),
                                create_toggle({label = localize('x2_click'), ref_table = BMAG.config, ref_value = 'x2_click'}),
                            }
                        }
                    }} end
                },
                {
                    label = localize('tabs_mouse_page_2'),
                    tab_definition_function = function() return {n = G.UIT.ROOT, config = tab_content_config, nodes={
                        create_toggle({label = localize('swap_mouse_wheel_up_with_down'), ref_table = BMAG.config, ref_value = 'swap_mouse_wheel_up_with_down'}),
                        create_toggle({label = localize('swap_x1_with_x2'), ref_table = BMAG.config, ref_value = 'swap_x1_with_x2'}),
                        create_toggle({label = localize('swap_mouse_wheel_with_x1_and_x2'), ref_table = BMAG.config, ref_value = 'swap_mouse_wheel_with_x1_and_x2'}),
                    }} end
                },
                {
                    label = localize('tabs_gamepad'),
                    tab_definition_function = function() return {n = G.UIT.ROOT, config = tab_content_config, nodes={
                        create_toggle({label = localize('b_click_or_hold'), ref_table = BMAG.config, ref_value = 'b_click_or_hold', info = localize('b_click_or_hold_info')}),
                        create_toggle({label = localize('rightstick_click_or_hold'), ref_table = BMAG.config, ref_value = 'rightstick_click_or_hold', info = localize('rightstick_click_or_hold_info')}),
                        create_toggle({label = localize('left_shoulder_click'), ref_table = BMAG.config, ref_value = 'left_shoulder_click'}),
                        create_toggle({label = localize('right_shoulder_click'), ref_table = BMAG.config, ref_value = 'right_shoulder_click'}),
                        create_toggle({label = localize('swap_a_with_b'), ref_table = BMAG.config, ref_value = 'swap_a_with_b'}),
                    }} end
                },
                {
                    label = localize('tabs_help'),
                    tab_definition_function = function() return {n = G.UIT.ROOT, config = tab_content_config, nodes={
                        {n = G.UIT.T, config = {text = localize('help'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT}},
                    }} end
                },
            }
        })
    }}
end
------------------------------------
-----------CONFIG MENU END----------

C = G.CONTROLLER

R_clicked = {target = nil, handled = true, prev_target = nil}
R_dragging = {target = nil, handled = true, prev_target = nil, start = false, can = false}
R_cursor_down = {T = {x=0, y=0}, target = nil, time = 0, handled = true}
R_cursor_up = {T = {x=0, y=0}, target = nil, time = 0.1, handled = true}
M_clicked = {handled = true}
M_cursor_down = {handled = true}
M_cursor_up = {handled = true}
Game_last_state = G.STATES.SPLASH
Game_state_change_to_selecting_hand = false --prevent repetitive playing card and discarding

--------------------------------------------------
------------LOVE2D FUNCTION REWRITING-------------
function love.gamepadpressed(joystick, button)
    button = G.button_mapping[button] or button
    button = gpad_button_mapping[button] or button
    if BMAG.config.swap_a_with_b then
        if button == 'a' then button = 'b' elseif button == 'b' then button = 'a' end
    end
	G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_press(button)
end

function love.gamepadreleased(joystick, button)
	button = G.button_mapping[button] or button
    button = gpad_button_mapping[button] or button
    if BMAG.config.swap_a_with_b then
        if button == 'a' then button = 'b' elseif button == 'b' then button = 'a' end
    end
    G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_release(button)
end

function love.mousepressed(x, y, button, touch)
    C:set_HID_flags(touch and 'touch' or 'mouse')
    if mouse_button_mapping[button] == 'left_mouse_button' then 
        C:queue_L_cursor_press(x, y)
	end
    if mouse_button_mapping[button] == 'right_mouse_button' then 
        C:queue_R_cursor_press(x, y)
	end
    if mouse_button_mapping[button] == 'middle_mouse_button' then 
		queue_M_cursor_press()
	end

    local is_x1 = mouse_button_mapping[button] == 'x1'
    local is_x2 = mouse_button_mapping[button] == 'x2'
    local is_x_swapped = BMAG.config.swap_x1_with_x2
    local is_wheel_swapped = BMAG.config.swap_mouse_wheel_with_x1_and_x2
    if (is_x1 and not is_swapped) or (is_x2 and is_swapped) then
        if not is_wheel_swapped then
            queue_X1_cursor_press()
        else
            queue_D_wheel_press()
        end
    elseif (is_x2 and not is_swapped) or (is_x1 and is_swapped) then
        if not is_wheel_swapped then
            queue_X2_cursor_press()
        else
            queue_U_wheel_press()
        end
    end
end

function love.mousereleased(x, y, button)
    if mouse_button_mapping[button] == 'left_mouse_button' then C:L_cursor_release(x, y) end
    if mouse_button_mapping[button] == 'right_mouse_button' then R_cursor_release(x, y) end
	if mouse_button_mapping[button] == 'middle_mouse_button' then M_cursor_release(x, y) end
end

function love.wheelmoved(x, y)
    y = BMAG.config.swap_mouse_wheel_up_with_down and -y or y
    if y > 0 then 
        if not BMAG.config.swap_mouse_wheel_with_x1_and_x2 then
		    queue_U_wheel_press()
        else
            queue_X2_cursor_press()
        end
    end
    if y < 0 then 
        if not BMAG.config.swap_mouse_wheel_with_x1_and_x2 then
		    queue_D_wheel_press()
        else
            queue_X1_cursor_press()
        end
    end
end
----------LOVE2D FUNCTION REWRITING END-----------
--------------------------------------------------

------------------------------------------
------------CONTROLLER UPDATE-------------
local update_ref = Controller.update
function Controller.update(self, dt)
    update_ref(self, dt)

    if Game_last_state ~= G.STATES.SELECTING_HAND and G.STATE == G.STATES.SELECTING_HAND then
        Game_state_change_to_selecting_hand = true
    end
    if Game_last_state == G.STATES.SELECTING_HAND and G.STATE ~= G.STATES.SELECTING_HAND then
        Game_state_change_to_selecting_hand = false
    end
    Game_last_state = G.STATE

    if R_cursor_queue then 
        R_cursor_press(R_cursor_queue.x, R_cursor_queue.y)
        R_cursor_queue = nil
    end

    if M_cursor_queue then 
        M_cursor_press()
        M_cursor_queue = nil
    end

    --right_mouse_button
    if not R_cursor_down.handled then
        if BMAG.config.right_mouse_button_hold then
            R_dragging.can = true
        end
        R_cursor_down.handled = true
    end
    if R_dragging.can
        and not R_dragging.start 
        and R_dragging.handled 
        and R_clicked.handled 
        and R_cursor_down.target then
        --Was the Cursor release in the same location as the Cursor press?
        if Vector_Dist(R_cursor_down.T, C.cursor_hover.T) >= 0.1*G.MIN_CLICK_DIST then 
            R_dragging.handled = false
            R_dragging.start = true
            R_dragging.can = false
        end
    end
    if not R_cursor_up.handled then 
        --First, stop dragging
        R_dragging.prev_target = nil
        R_dragging.handled = true
        R_dragging.can = false
        R_dragging.start = false  
        --Now, handle the Cursor release
        --Was the Cursor release in the same location as the Cursor press?
        if R_cursor_down.target and BMAG.config.right_mouse_button_click then 
            if (not R_cursor_down.target.click_timeout or R_cursor_down.target.click_timeout*G.SPEEDFACTOR > R_cursor_up.time - R_cursor_down.time) then
                if R_cursor_down.target.states.click.can then
                    if Vector_Dist(R_cursor_down.T, R_cursor_up.T) < 0.1*G.MIN_CLICK_DIST then 
                        R_clicked.handled = false
                    end
                end
            end
        end
        R_cursor_up.handled = true
    end

    --middle_mouse_button
    if not BMAG.config.middle_mouse_button_hold and BMAG.config.middle_mouse_button_click then
        if not M_cursor_down.handled then
            if ((C.locked) and not G.SETTINGS.paused) or (C.locks.frame) or (C.frame_buttonpress) then
            else
                M_clicked.handled = false
            end
            M_cursor_down.handled = true
        end
        if not M_cursor_up.handled then
            M_cursor_up.handled = true
        end
    else
        if not M_cursor_down.handled then
            if BMAG.config.middle_mouse_button_hold or BMAG.config.middle_mouse_button_click then
                C:key_press('r')
            end
            M_cursor_down.handled = true
        end
        if not M_cursor_up.handled then
            if not BMAG.config.middle_mouse_button_click or ((C.locked) and not G.SETTINGS.paused) or (C.locks.frame) or (C.frame_buttonpress) then
            else
                if C.held_key_times['r'] and C.held_key_times['r'] <= 0.7 then
                    M_clicked.handled = false
                end
            end
            if BMAG.config.middle_mouse_button_hold or BMAG.config.middle_mouse_button_click then
                C:key_release('r')
            end
            M_cursor_up.handled = true
        end
    end

    ----Sending all input updates to the game objects----
    --unselect by clicking right_mouse_button
    if not R_clicked.handled then
        if not G.SETTINGS.paused and G.hand and G.hand.highlighted[1] then 
            if (G.play and #G.play.cards > 0) or
                (C.locked) or 
                (C.locks.frame) or
                (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then return end
            G.hand:unhighlight_all()
        end   

        R_clicked.handled = true
    end
    
    --multiply select by dragging with right_mouse_button
    if not R_dragging.handled 
        and C.hovering.target 
        and C.hovering.target:is(Card) 
        and C.hovering.target.area == G.hand then
        if R_dragging.start then
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
            R_dragging.start = false
        elseif C.hovering.prev_target ~= C.hovering.target then 
            if R_dragging.prev_target == C.hovering.target then 
                if C.hovering.prev_target:is(Card) then
                    C.hovering.prev_target:click()
                end
        end
            C.hovering.target:click()
            R_dragging.prev_target = C.hovering.prev_target
        end
    end

    --escape by clicking middle_mouse_button
    if not M_clicked.handled then
        C:key_press('escape')
        M_clicked.handled = true
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
            (not G.CONTROLLER.HID.mouse and not G.CONTROLLER.HID.axis_cursor) then 
            else
                C:L_cursor_press()
            end
        end
        --modification of this function start
        if button == 'b' then 
            if G.hand and C.focused.target and
            C.focused.target.area == G.hand and 
            BMAG.config.b_click_or_hold then
                C:queue_R_cursor_press()
            else
                C.interrupt.focus = true
            end
        end
        if G.STATE == G.STATES.SELECTING_HAND then
            if button == 'leftshoulder' and BMAG.config.left_shoulder_click then
                G.FUNCS.sort_hand_value()
            elseif button == 'rightshoulder' and BMAG.config.right_shoulder_click then
                G.FUNCS.sort_hand_suit()
            end
        end
        if button == 'rightstick' and BMAG.config.rightstick_click_or_hold then 
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

    --holding 'b' is same as holding right_mouse_button
    if button == 'b' and BMAG.config.b_click_or_hold then
        R_cursor_release()
    end

    if button == 'rightstick' and BMAG.config.rightstick_click_or_hold then
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

function queue_X1_cursor_press()
    if C.locks.frame or not BMAG.config.x1_click then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND then 
        G.FUNCS.sort_hand_suit()
    end
end

function queue_X2_cursor_press()
    if C.locks.frame or not BMAG.config.x2_click then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND then 
        G.FUNCS.sort_hand_value()
    end
end

function queue_U_wheel_press()
    if C.locks.frame or not BMAG.config.middle_mouse_button_up then return end
    if C.cursor_down.target and C.cursor_down.target.states.drag.is then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND and Game_state_change_to_selecting_hand then
        local play_button = G.buttons:get_UIE_by_ID('play_button')
        if play_button and play_button.config.button then
            G.FUNCS.play_cards_from_highlighted()
            Game_state_change_to_selecting_hand = false
        end
    end
end

function queue_D_wheel_press()
    if C.locks.frame or not BMAG.config.middle_mouse_button_down then return end
    if C.cursor_down.target and C.cursor_down.target.states.drag.is then return end
    if not G.SETTINGS.paused and G.STATE == G.STATES.SELECTING_HAND and Game_state_change_to_selecting_hand then
        local discard_button = G.buttons:get_UIE_by_ID('discard_button')
        if discard_button and discard_button.config.button then
            G.FUNCS.discard_cards_from_highlighted()
            Game_state_change_to_selecting_hand = false
        end
    end
end

function R_cursor_press(x, y)
    x = x or C.cursor_position.x
    y = y or C.cursor_position.y

    if ((C.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (C.locks.frame) then return end

    R_cursor_down.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    R_cursor_down.time = G.TIMERS.TOTAL
    R_cursor_down.handled = false
    R_cursor_down.target = nil

    local press_node =  (C.HID.touch and C.cursor_hover.target) or C.hovering.target or C.focused.target

    if press_node then 
        R_cursor_down.target = press_node.states.click.can and press_node or press_node:can_drag() or nil
    end

    if R_cursor_down.target == nil then 
        R_cursor_down.target = G.ROOM
    end
end

function R_cursor_release(x, y)
    x = x or C.cursor_position.x
    y = y or C.cursor_position.y

    if ((C.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (C.locks.frame) then return end

    R_cursor_up.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    R_cursor_up.time = G.TIMERS.TOTAL
    R_cursor_up.handled = false
    R_cursor_up.target = nil

    R_cursor_up.target = C.hovering.target or C.focused.target

    if R_cursor_up.target == nil then 
        R_cursor_up.target = G.ROOM
    end
end

function M_cursor_press()
    M_cursor_down.handled = false
end

function M_cursor_release()
    M_cursor_up.handled = false
end
----------PRESS AND RELEASE END-----------
------------------------------------------

----------------------------------------------
------------MOD CODE END----------------------
