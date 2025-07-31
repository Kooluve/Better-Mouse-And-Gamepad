--- bindmap.lua
--
--  This file contains the @{BindMap} object.

--- A map of all custom binds set by the mod.
-- Binds a button code to a Lua function.
-- Used to determine whether or not to fallback to the standard Love2D event handling.
-- Uses 2 maps, one for each association direction to make lookup much faster.
--
-- @field button_to_binding an associative array of keycodes to @{Binding} objects
-- @field binding_to_button an associative array of @{Binding} objects to keycodes
BindMap = {
    binding_to_button = {},
    click = {},
    hold = {},
};

--- Creates a new @{BindMap}.
-- Creates a new @{BindMap}; should only be run once during runtime.
--
-- @return the new @{BindMap}
function BindMap:new()
    local im = {
        binding_to_button = {},
        click = {},
        hold = {},
    };
    setmetatable(im, self);
    self.__index = self;
    return im;
end

--- Creates a new @{BindMap}.
-- Creates a new @{BindMap}; should only be run once during runtime.
--
-- @return the new @{BindMap}
function BindMap:from(bm)
    setmetatable(bm, self);
    self.__index = self;
    return bm;
end

--- Gets the associated @{Binding} for a button.
--
-- @param button the keycode to query
-- @return the queried @{Binding}, or nil
function BindMap:get(button, hold)
    if hold then
        return self.hold[button];
    else
        return self.click[button];
    end
end

--- Gets the associated button for a binding id.
--
-- @param binding the binding id to query
-- @return the queried button, or nil
function BindMap:get_button(binding)
    return self.binding_to_button[binding];
end

--- Removes the associated @{Binding} for a button.
--
-- @param button the keycode to remove
-- @return the BindMap instance
function BindMap:remove(button, hold)
    if hold then
        self.hold[button] = nil;
    else
        self.click[button] = nil;
    end
    return self;
end

--- Removes the associated button for a binding id.
--
-- @param binding the binding id to remove
-- @return the BindMap instance
function BindMap:remove_binding(binding)
    local b = self.binding_to_button[binding];
    self.binding_to_button[binding] = nil;
    if b == nil then return self; end
    self:remove(b.button, b.hold);
    return self;
end

--- Checks whether a button is bound or not
-- A boolean representing whether or not a key has been bound to anything.
--
-- @param button the keycode to check
-- @return true if bound, false if not
function BindMap:is_bound(button)
    local click = false;
    local hold = false;
    if self:get(button, false) then
        click = true;
    elseif self:get(button, true) then
        hold = true;
    end

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

function BindMap:bind_hold(button, fn_id)
    if self:get_button(fn_id) then
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

function BindMap:bind_click(button, fn_id)
    -- multiselect is hold-only
    if fn_id == 'multiselect' then
        return self;
    end
    if self:get_button(fn_id) then
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
