--[[
    TimerTable

    Monotonic int clock table; increments by 1 each frame during keypress, so not
    real-time. Lua's table library should do most of the heavy lifting. Used to
    determine if a keypress is a held or clicked key. If the timer passes a user's
    set threshold, it is a hold event, else it is a click. Effectively clicks are
    handled upon keyrelease, while holds start handling a given threshold after
    keypress.
--]]
TimerTable = {};

--[[
    TimerTable:new() -> TimerTable

    Creates a new TimerTable.

    Example:
    local timers = TimerTable:new()   -- creates new empty TimerTable
--]]
function TimerTable:new()
    local t = {};
    setmetatable(t, self);
    self.__index = self;
    return t;
end

--[[
    TimerTable:start(button: Keycode) -> Self

    Starts a timer for the specified button.
--]]
function TimerTable:start(button)
    self[button] = 0;
    return self;
end

--[[
    TimerTable:stop(button: Keycode) -> Self

    Stops the timer for the specified button.
--]]
function TimerTable:stop(button)
    self[button] = nil;
    return self;
end
--[[
    TimerTable:get(button: Keycode) -> Int

    Gets the current timer duration for the specified button.
--]]
function TimerTable:get(button)
    return self[button];
end

--[[
    TimerTable:increment() -> Self

    Increments all timers currently active in the TimerTable by 1.
--]]
function TimerTable:increment()
    for i, v in self do
        self[i] = v + 1;
    end
    return self;
end
