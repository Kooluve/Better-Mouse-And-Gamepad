-------------
-- IMPORTS --
-------------
-- `./timers.lua`: A timer table for checking keypress duration
assert(SMODS.load_file('libs/timers.lua'))();
-- `./queue.lua`: A simple FIFO queue implementation
assert(SMODS.load_file('libs/queue.lua'))();

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
    timers = TimerTable:new(),
    queue = Queue:new(),
};


