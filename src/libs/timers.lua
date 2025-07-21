--- timers.lua
--
--  This file contains the @{TimerTable} object.

--- A table of monotoninc integer clocks.
-- Checked every frame to determine whether to send a click or hold event.
TimerTable = {};

--- Creates a new TimerTable.
-- Creates a new empty TimerTable.
--
-- Example:
-- local timers = TimerTable:new()
--
-- @return the new TimerTable instance
function TimerTable:new()
    local t = {};
    setmetatable(t, self);
    self.__index = self;
    return t;
end

--- Starts a timer for the specified button.
-- Sets the timer to `0` for the given button.
--
-- @param button the keycode to begin a timer for
-- @return the @{TimerTable} instance for chain-calling
function TimerTable:start(button)
    self[button] = 0;
    return self;
end

--- Stops a timer for the specified button.
-- Sets the timer to `nil` for the given button.
--
-- @param button the keycode to stop the timer for
-- @return the @{TimerTable} instance for chain-calling
function TimerTable:stop(button)
    self[button] = nil;
    return self;
end

--- Gets the elapsed time for the specified button.
-- Gets the amount of updates since the button was pressed last.
--
-- @param button the keycode to return the elapsed time for
-- @return the amount of time elapsed
function TimerTable:get(button)
    return self[button];
end

--- Increments all active timers.
-- Runs on every controller update cycle; iterates over all entries in the TimerTable instance
-- and adds `1` to the value of all of the timers.
--
-- @return the @{TimerTable} instance for chain-calling
function TimerTable:increment()
    for i, v in self do
        self[i] = v + 1;
    end
    return self;
end
