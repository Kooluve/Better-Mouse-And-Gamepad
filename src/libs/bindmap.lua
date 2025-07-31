--- bindmap.lua
--
--  This file contains the @{BindMap} object and all relevant methods and functions.

--- A map of all custom binds set by the mod.
-- Binds a button code to a Lua function.
-- Used to determine whether or not to fallback to the standard Love2D event handling.
-- Uses 3 maps, one for clicks, one for holds, and a reverse table to make lookup much faster.
--
-- @field binding_to_button an associative array of binding objects to keycodes
--     elements are of the format { button = <keycode>, hold = <boolean> }
-- @field click an array of feature names ('multiselect', 'deselect', etc) indexable by keycode.
--     elements are nullable strings
-- @field hold an array of feature names ('multiselect', 'deselect', etc) indexable by keycode.
--     elements are nullable strings
BindMap = {
    binding_to_button = {},
    click = {},
    hold = {},
};

--- Creates the default @{BindMap}.
-- Creates the default @{BindMap}; should only be run once during runtime.
--
-- @return the new @{BindMap}
function BindMap:new()
    local im = {
        binding_to_button = {
            ['multiselect'] = {
                button = 'mouse2',
                hold = true,
            },
            ['deselect'] = {
                button = 'mouse2',
                hold = false,
            },
            ['sort_suit'] = {
                button = 'wheel_up',
                hold = false,
            },
            ['sort_val'] = {
                button = 'wheel_down',
                hold = false,
            },
            ['play'] = {
                button = 'mouse5',
                hold = false,
            },
            ['discard'] = {
                button = 'mouse4',
                hold = false,
            },
        },
        click = {
            ['mouse2'] = 'deselect',
            ['wheel_up'] = 'sort_suit',
            ['wheel_down'] = 'sort_val',
            ['mouse5'] = 'play',
            ['mouse4'] = 'discard',
        },
        hold = {
            ['mouse2'] = 'multiselect',
        },
    };
    setmetatable(im, self);
    self.__index = self;
    return im;
end

--- Creates a new @{BindMap} from populated fields.
-- Creates a new @{BindMap}; can be used to apply metatables to a loaded bindmap.
--
-- @param bm an object of the format { binding_to_button = {}, click = {}, hold = {} }
-- @return the new @{BindMap}
function BindMap:from(bm)
    setmetatable(bm, self);
    self.__index = self;
    return bm;
end

--- Removes the associated button for a binding id.
--
-- @param binding the binding id to remove
-- @return the BindMap instance
function BindMap:remove_binding(binding)
    local b = self.binding_to_button[binding];
    self.binding_to_button[binding] = nil;
    if b == nil then return self; end
    if b.hold then
        self.hold[b.button] = nil;
    else
        self.click[b.button] = nil;
    end
    return self;
end

--- Checks whether a button is bound or not
--
-- @param button the keycode to check
-- @return 'both', 'click', or 'hold' if bound, nil if not
function BindMap:is_bound(button)
    local click = self.click[button];
    local hold = self.hold[button];

    if click and hold then
        return 'both';
    elseif click then
        return 'click';
    elseif hold then
        return 'hold';
    else
        return nil;
    end
end

--- Binds a hold event to a particular function
--
-- @param button the keycode to bind
-- @param fn_id the string representation of the function (e.g 'multiselect', 'deselect', etc.)
-- @return the {@BindMap} instance for chain-calling
function BindMap:bind_hold(button, fn_id)
    if self.binding_to_button[fn_id] then
        self:remove_binding(fn_id);
    end
    local old_fn = self.hold[button];
    if old_fn then
        self.binding_to_button[old_fn] = nil;
        regen_bindbar(STATE.cfg_gui_parent.UIBox:get_UIE_by_ID(old_fn));
    end
    self.hold[button] = fn_id;
    self.binding_to_button[fn_id] = {
        button = button,
        hold = true,
    };
    return self;
end

--- Binds a click event to a particular function
--
-- @param button the keycode to bind
-- @param fn_id the string representation of the function (e.g 'multiselect', 'deselect', etc.)
-- @return the {@BindMap} instance for chain-calling
function BindMap:bind_click(button, fn_id)
    -- multiselect is hold-only
    if fn_id == 'multiselect' then
        return self;
    end
    if self.binding_to_button[fn_id] then
        self:remove_binding(fn_id);
    end
    local old_fn = self.click[button];
    if old_fn then
        self.binding_to_button[old_fn] = nil;
        regen_bindbar(STATE.cfg_gui_parent.UIBox:get_UIE_by_ID(old_fn));
    end
    self.click[button] = fn_id;
    self.binding_to_button[fn_id] = {
        button = button,
        hold = false,
    };
    return self;
end

--- Starts the bound `click` function for a given button
--
-- @param button the keycode to click
function BindMap:on_click(button)
    local fn = self.click[button];
    if fn == nil then
        return;
    elseif fn == 'deselect' then
        deselect_all()
    elseif fn == 'sort_suit' then
        sort_by_suit();
    elseif fn == 'sort_val' then
        sort_by_value();
    elseif fn == 'play' then
        play_hand();
    elseif fn == 'discard' then
        discard_hand();
    elseif fn == 'restart' then
        restart_game();
    end
end

--- Starts the bound `hold` function for a given button
--
-- @param button the keycode to hold
function BindMap:hold_start(button)
    local fn = self.hold[button];
    if fn == nil then
        return;
    elseif fn == 'deselect' then
        deselect_all();
    elseif fn == 'sort_suit' then
        sort_by_suit();
    elseif fn == 'sort_val' then
        sort_by_value();
    elseif fn == 'play' then
        play_hand();
    elseif fn == 'discard' then
        discard_hand();
    elseif fn == 'restart' then
        restart_game();
    end
end
