--- STEAMODDED HEADER
--- MOD_NAME: Better Mouse And Gamepad
--- MOD_ID: BetterMouseAndGamepad
--- MOD_AUTHOR: [Kooluve]
--- MOD_DESCRIPTION: Make mouse and gamepad more efficient and easier to use. View "README.md" and "*.lua" file for all functions and settings.
----------------------------------------------
------------MOD CODE -------------------------

--[[
-------------------------------------
--------FUNCTIONS DESCRIPTION--------
01. click right mouse button     -> unselect all cards
02. hold right mouse button      -> multiply select cards (core function!)
03. click middle mouse button    -> esc
04. hold middle mouse button     -> quickly restart (same as key "r")
05. middle mouse up              -> play cards
06. middle mouse down            -> discard cards
07. click X1 mouse button        -> sort hand by suit
08. click X2 mouse button        -> sort hand by value
09. hold gamepad b button        -> same as hold right mouse button
10. click gamepad left shoulder  -> same as click X1 mouse button
11. click gamepad right shoulder -> same as click X2 mouse button
12. hold gamepad right stick     -> same as hold middle mouse button
-------------------------------------
------FUNCTIONS DESCRIPTION END------

-------------------------------------
------------ABBREVIATION-------------
l, r, m       -> left, right, middle
lmb, rmb, mmb -> left, right, middle mouse button
x1, x2        -> X1, X2 mouse buttion
gpad          -> gamepad
a, b, x, y    -> gamepad a, b, x, y button
lsd, rsd      -> leftshoulder, rightshoulder
lst, rst      -> leftstick, rightstick
-------------------------------------
----------ABBREVIATION END-----------
--]]

-------------------------------------
------------USER SETTING-------------
--in orighinal game, no matter you use what gamepad, the comfirm button is always the bottom face button same as xbox
--set parameter to false below to turn function off
--note that if you turn certain function off, you ban the function, not the button, 
--so if then you swap it's mapping, this button will still work to execute the other function
mod_functions_can = {
    ["rmb_click"] = true,
    ["rmb_hold"] = true,
    ["mmb_click"] = true,
    ["mmb_hold"] = true,
    ["mmb_up"] = true,
    ["mmb_down"] = true,
    ["x1_click"] = true,
    ["x2_click"] = true,
    ["b_hold"] = true,
    ["lsd_click"] = true,
    ["rsd_click"] = true,
    ["rst_hold"] = true
}

--set parameter to true to swap mapping
SWAP_MOUSE_WHEEL_UP_WITH_DOWN = false
SWAP_MOUSE_WHEEL_WITH_X1_X2 = false

--exchange the number with other existing number left to "=" to modify mouse button mapping
mouse_button_mapping = {
    [1] = "lmb",
    [2] = "rmb",
    [3] = "mmb",
    [4] = "x1",
    [5] = "x2",
}

--exchange the string with other existing string left to "=" to modify mouse button mapping
gpad_button_mapping = {
    ["a"] = "a",
    ["b"] = "b",
    ["x"] = "x",
    ["y"] = "y",
    ["leftshoulder"] = "leftshoulder",
    ["rightshoulder"] = "rightshoulder",
    ["back"] = "back",
    ["start"] = "start",
    ["dpleft"] = "dpleft",
    ["dpright"] = "dpright",
    ["dpup"] = "dpup",
    ["dpdown"] = "dpdown",
    ["leftstick"] = "leftstick", --no function in original game
    ["rightstick"] = "rightstick", --no function in original game
    -- can't map trigger to other button, reason unknown, maybe need to modify ui functions
    -- ["triggerleft"] = "triggerleft",
    -- ["triggerright"] = "triggerright",
}
-------------------------------------
-----------USER SETTING END----------

C = G.CONTROLLER

R_clicked = {target = nil, handled = true, prev_target = nil}
R_dragging = {target = nil, handled = true, prev_target = nil, start = false, can = false}
R_cursor_down = {T = {x=0, y=0}, target = nil, time = 0, handled = true}
R_cursor_up = {T = {x=0, y=0}, target = nil, time = 0.1, handled = true}
M_clicked = {handled = true}
M_cursor_down = {handled = true}
M_cursor_up = {handled = true}

--------------------------------------------------
------------LOVE2D FUNCTION REWRITING-------------
function love.gamepadpressed(joystick, button)
    button = G.button_mapping[button] or button
    button = gpad_button_mapping[button] or button
	G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_press(button)
end

function love.gamepadreleased(joystick, button)
	button = G.button_mapping[button] or button
    button = gpad_button_mapping[button] or button
    G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_release(button)
end

function love.mousepressed(x, y, button, touch)
    C:set_HID_flags(touch and 'touch' or 'mouse')
    if mouse_button_mapping[button] == "lmb" then 
        C:queue_L_cursor_press(x, y)
	end
    if mouse_button_mapping[button] == "rmb" then 
        C:queue_R_cursor_press(x, y)
	end
    if mouse_button_mapping[button] == "mmb" then 
		queue_M_cursor_press()
	end
    if mouse_button_mapping[button] == "x1" then 
        if not SWAP_MOUSE_WHEEL_WITH_X1_X2 then
		    queue_X1_cursor_press()
        else
            queue_D_wheel_press()
        end
	end
    if mouse_button_mapping[button] == "x2" then 
        if not SWAP_MOUSE_WHEEL_WITH_X1_X2 then
		    queue_X2_cursor_press()
        else
            queue_U_wheel_press()
        end
	end
end

function love.mousereleased(x, y, button)
    if mouse_button_mapping[button] == "lmb" then C:L_cursor_release(x, y) end
    if mouse_button_mapping[button] == "rmb" then R_cursor_release(x, y) end
	if mouse_button_mapping[button] == "mmb" then M_cursor_release(x, y) end
end

function love.wheelmoved(x, y)
    y = SWAP_MOUSE_WHEEL_UP_WITH_DOWN and -y or y
    if y > 0 then 
        if not SWAP_MOUSE_WHEEL_WITH_X1_X2 then
		    queue_U_wheel_press()
        else
            queue_X2_cursor_press()
        end
    end
    if y < 0 then 
        if not SWAP_MOUSE_WHEEL_WITH_X1_X2 then
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

    if R_cursor_queue then 
        R_cursor_press(R_cursor_queue.x, R_cursor_queue.y)
        R_cursor_queue = nil
    end

    if M_cursor_queue then 
        M_cursor_press()
        M_cursor_queue = nil
    end

    --rmb
    if not R_cursor_down.handled then
        if mod_functions_can["rmb_hold"] then
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
        if R_cursor_down.target and mod_functions_can["rmb_click"] then 
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

    --mmb
    if not M_cursor_down.handled then
        if mod_functions_can["mmb_hold"] then
            C:key_press('r')
        end
        M_cursor_down.handled = true
    end
    if not M_cursor_up.handled then
        if not mod_functions_can["mmb_click"] or ((C.locked) and not G.SETTINGS.paused) or (C.locks.frame) or (C.frame_buttonpress) then
        else
            if C.held_key_times['r'] and C.held_key_times['r'] <= 0.7 then
                M_clicked.handled = false
            end    
        end
        if mod_functions_can["mmb_hold"] then
            C:key_release('r')
        end
        M_cursor_up.handled = true
    end

    ----Sending all input updates to the game objects----
    --unselect by clicking rmb
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
    
    --multiply select by dragging with rmb
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

    --escape by clicking mmb
    if not M_clicked.handled then
        C:key_press('escape')
        M_clicked.handled = true
    end
end
----------CONTROLLER UPDATE END-----------
------------------------------------------

----------------------------------------------
------------GAMEPAD BUTTON UPDATE-------------
local button_press_update_ref = Controller.button_press_update
function Controller.button_press_update(self, button, dt)
    button_press_update_ref(self, button, dt)

    --swap hand sort by clicking shoulder
    if not G.SETTINGS.paused and G.hand then
        if button == 'leftshoulder' and mod_functions_can["lsd_click"] then
            G.FUNCS.sort_hand_value()
        elseif button == 'rightshoulder' and mod_functions_can["rsd_click"] then
            G.FUNCS.sort_hand_suit()
        end
    end
  
    if button == 'b' and mod_functions_can["b_hold"] then
        R_cursor_release()
    end

    if mod_functions_can["rst_hold"] and not (C.button_registry[button] and C.button_registry[button][1] and not C.button_registry[button][1].node.under_overlay) then     
        --holding "a" and "b" together is same as holding mmd
        if button == 'rightstick' then 
            queue_M_cursor_press()
        end
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

    --holding "b" is same as holding rmb
    if button == 'b' and mod_functions_can["b_hold"] then
        R_cursor_release()
    end

    if button == 'rightstick' and mod_functions_can["rst_hold"] then
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
    if C.locks.frame or not mod_functions_can["x1_click"] then return end
    if not G.SETTINGS.paused and G.hand then 
        G.FUNCS.sort_hand_suit()
    end
end

function queue_X2_cursor_press()
    if C.locks.frame or not mod_functions_can["x2_click"] then return end
    if not G.SETTINGS.paused and G.hand then 
        G.FUNCS.sort_hand_value()
    end
end

function queue_U_wheel_press()
    if C.locks.frame or not mod_functions_can["mmb_up"] then return end
    if not G.SETTINGS.paused and G.hand and G.hand.highlighted[1] and G.GAME.current_round.hands_left > 0 then
        G.FUNCS.play_cards_from_highlighted()
    end
end

function queue_D_wheel_press()
    if C.locks.frame or not mod_functions_can["mmb_down"] then return end
    if not G.SETTINGS.paused and G.hand and G.hand.highlighted[1] and G.GAME.current_round.discards_left > 0 then
        G.FUNCS.discard_cards_from_highlighted()
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
