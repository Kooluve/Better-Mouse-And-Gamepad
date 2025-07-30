--- Imports
-- `./bindmap.lua`: A keybind map for ease of lookup and management
-- `./config.lua`: Includes all config menu declarations and functions
-- `./input.lua`: The Love2D event hook override functions
-- `./feats.lua`: The main "feature" functions for the mod
-- `./timers.lua`: A timer table for checking keypress duration
assert(SMODS.load_file('src/libs/bindmap.lua'))();
assert(SMODS.load_file('src/libs/config.lua'))();
assert(SMODS.load_file('src/libs/input.lua'))();
assert(SMODS.load_file('src/libs/feats.lua'))();
assert(SMODS.load_file('src/libs/timers.lua'))();

--- BMAG mutable state.
-- Contains all mutable state for the mod.
--
-- @field bind_map @{BindMap} for binding input
-- @field timers @{TimerTable} for checking keypress duration
-- @field listening an Option<string> of the binding function listening for keypresses
-- @field cfg_gui_parent a reference to the keybind menu parent, for updating outside of button presses
-- @field multiselecting true on first mousepress, false while multiselecting, and nil when not
-- @field prev_prev_target contains the last value of G.CONTROLLER.prev_target for switching drag direction
STATE = {
    bind_map = BindMap:new(),
    timers = TimerTable:new(),
    listening = nil,
    cfg_gui_parent = nil,
    multiselecting = nil,
    prev_prev_target = nil,
};
