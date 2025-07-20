--  l2d.lua
--  This file contains the Love2D Event Hooks. All hooks should point to
--  utility functions elsewhere, but this is where they interface with L2D.

-- All functions in this file work by overriding the default event hooks in Love2D.
-- Default event hooks are used as fallback when the input signal being handled
-- is not bound to a mod feature in the InputMap.

--[[
    love.mousepressed(x, y, button, touch)

    Mouse press event hook
--]]
local mousepressed_fb = love.mousepressed;      -- old event hook used for fallback
function love.mousepressed(x, y, button, touch)
    local mapped_input = STATE.input_map:get(button);
    if mapped_input then
        mapped_input:on_press(x, y, button, touch)
    else
        mousepressed_fb(x, y, button, touch);
    end
end

--[[
    love.mousereleased(x, y, button)

    Mouse release event hook
--]]
local mousereleased_fb = love.mousereleased;    -- old event hook used for fallback
function love.mousereleased(x, y, button, touch)
    local mapped_input = STATE.input_map:get(button);
    if mapped_input then
        mapped_input:on_release(x, y, button, touch)
    else
        mousereleased_fb(x, y, button, touch);
    end
end

--[[
    love.wheelmoved(x, y)

    Mouse wheel movement event hook
--]]
local wheelmoved_fb = love.wheelmoved;          -- old event hook used for fallback
function love.wheelmoved(x, y)
    -- L2D does not store mouse wheel movement as a KeyCode; spoofing with pseudovalues
    local button = 'wheel_error';

    -- check wheel movement direction
    -- TODO: find out what x direction wheel movement represents and handle if needed;
    if y > 0 then
        button = 'wheel_up';
    elseif y < 0 then
        button = 'wheel_down';
    end

    local mapped_input = STATE.input_map:get(button);
    if mapped_input then
        mapped_input:on_press(x, y, button, nil);
        mapped_input:on_release(x, y, button, nil);
    else
        wheelmoved_fb(x, y);
    end
end

--[[
    love.gamepadpressed(joystick, button)

    Gamepad button press event hook
--]]
local gamepadpressed_fb = love.gamepadpressed;
function love.gamepadpressed(joystick, button)
    local mapped_input = STATE.input_map:get(button);
    if mapped_input then
        mapped_input:on_press(nil, nil, button, nil);
    else
        gamepadpressed_fb(joystick, button);
    end
end

--[[
    love.gamepadreleased(joystick, button)

    Gamepad button release event hook
--]]
local gamepadreleased_fb = love.gamepadreleased;
function love.gamepadreleased(joystick, button)
    local mapped_input = STATE.input_map:get(button);
    if mapped_input then
        mapped_input:on_release(nil, nil, button, nil);
    else
        gamepadreleased_fb(joystick, button);
    end
end
