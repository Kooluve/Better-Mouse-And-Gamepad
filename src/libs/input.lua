--- input.lua
--
-- This file contains the Love2D input event hooks. All hooks should do is call
-- methods on the @{TimerTable} instance, which starts the mod's input pipeline.

-- old event hooks used for fallback
local mousepressed_fb = love.mousepressed;
local mousereleased_fb = love.mousereleased;
local wheelmoved_fb = love.wheelmoved;
local gamepadpressed_fb = love.gamepadpressed;
local gamepadreleased_fb = love.gamepadreleased;

--- Mouse press event hook.
-- Love2D mouse button press event override.
--
-- @param x cursor x position
-- @param y cursor y position
-- @param button cursor button pressed
-- @param istouch boolean true if from a touchscreen
function love.mousepressed(x, y, button, istouch)
    local mapped_input = STATE.bind_map:get(button);
    if mapped_input then
        STATE.timers.start(button);
    else
        mousepressed_fb(x, y, button, istouch);
    end
end

--- Mouse release event hook.
-- Love2D mouse button release event override.
--
-- @param x cursor x position
-- @param y cursor y position
-- @param button cursor button released
-- @param istouch boolean true if from a touchscreen
function love.mousereleased(x, y, button, istouch)
    local mapped_input = STATE.bind_map:get(button);
    if mapped_input then
        STATE.timers.stop(button);
    else
        mousereleased_fb(x, y, button, istouch);
    end
end

--- Mouse wheel movement event hook.
-- Love2D mouse wheel movement event override.
--
-- @param x mouse wheel x position delta
-- @param y mouse wheel y position delta
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

    local mapped_input = STATE.bind_map:get(button);
    if mapped_input then
        STATE.timers:start(button);
        STATE.timers:stop(button);
    else
        wheelmoved_fb(x, y);
    end
end

--- Gamepad button press event hook.
-- Love2D gamepad button press event override.
--
-- @param joystick the @{love.Joystick} object
-- @param button the button being pressed
function love.gamepadpressed(joystick, button)
    local mapped_input = STATE.bind_map:get(button);
    if mapped_input then
        STATE.timers:start(button);
    else
        gamepadpressed_fb(joystick, button);
    end
end

--- Gamepad button release event hook.
-- Love2D gamepad button release event override.
--
-- @param joystick the @{love.Joystick} object
-- @param button the button being released
function love.gamepadreleased(joystick, button)
    local mapped_input = STATE.bind_map:get(button);
    if mapped_input then
        STATE.timers:stop(button);
    else
        gamepadreleased_fb(joystick, button);
    end
end
