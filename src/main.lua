--- Imports
-- `./binding.lua`: A keybind object; stored in the BindMap
-- `./bindmap.lua`: A keybind map for ease of lookup and management
-- `./input.lua`: The Love2D event hook override functions
-- `./feats.lua`: The main "feature" functions for the mod
-- `./timers.lua`: A timer table for checking keypress duration
assert(SMODS.load_file('src/libs/binding.lua'))();
assert(SMODS.load_file('src/libs/bindmap.lua'))();
assert(SMODS.load_file('src/libs/input.lua'))();
assert(SMODS.load_file('src/libs/feats.lua'))();
assert(SMODS.load_file('src/libs/timers.lua'))();

--- BMAG mutable state.
-- Contains all mutable state for the mod.
--
-- @field bind_map @{BindMap} for binding input
-- @field timers @{TimerTable} for checking keypress duration
STATE = {
    bind_map = BindMap:new(),
    timers = TimerTable:new(),
};
