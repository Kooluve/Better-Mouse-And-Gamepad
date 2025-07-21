-------------
-- IMPORTS --
-------------
-- `./input.lua`: A keybind map for ease of lookup and management
-- `./l2d.lua`: The Love2D event hook override functions
-- `./timers.lua`: A timer table for checking keypress duration
-- `./queue.lua`: A simple FIFO queue implementation

assert(SMODS.load_file('src/libs/input.lua'))();
assert(SMODS.load_file('src/libs/l2d.lua'))();
assert(SMODS.load_file('src/libs/timers.lua'))();
assert(SMODS.load_file('src/libs/queue.lua'))();

------------------
-- GLOBAL STATE --
------------------
-- put any and all mutable state in here. we don't need 3 different state types...
--
-- `timers`:
--     See `./libs/timers.lua` for more details.
-- `queue`:
--     See `./libs/queue.lua` for more details.

STATE = {
    input_map = InputMap:new(),
    timers = TimerTable:new(),
    queue = Queue:new(),
};
