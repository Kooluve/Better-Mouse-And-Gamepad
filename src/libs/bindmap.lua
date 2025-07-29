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
    button_to_binding = {},
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
        button_to_binding = {},
        binding_to_button = {},
    };
    setmetatable(im, self);
    self.__index = self;
    return im;
end

--- Inserts a @{Binding} into the input map.
--
-- @param button the keycode to bind the @{Binding} to
-- @param binding the @{Binding} to be bound
-- @return the @{BindMap} instance for chain-calling
function BindMap:insert(button, binding, name, hold)
    self.button_to_binding[button] = binding;
    self.binding_to_button[name] = {
        button = button,
        hold = hold
    };
    if hold then
        self.hold[button] = true;
    else
        self.click[button] = true;
    end
    return self;
end

--- Gets the associated @{Binding} for a button.
--
-- @param button the keycode to query
-- @return the queried @{Binding}, or nil
function BindMap:get(button)
    return self.button_to_binding[button];
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
function BindMap:remove(button)
    self.button_to_binding[button] = nil;
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
    local bind = self.button_to_binding[b.button];
    if bind == nil then return self; end
    if b.hold then
        bind:unset_hold_start():unset_hold_end();
        self.hold[b.button] = false;
    else
        self.click[b.button] = false;
        bind:unset_click();
    end
    if
        bind:is_click_bound() or
        bind:is_hold_bound()
    then
        self.button_to_binding[b.button] = bind;
    else
        self:remove(b.button);
    end
    return self;
end

--- Checks whether a button is bound or not
-- A boolean representing whether or not a key has been bound to anything.
--
-- @param button the keycode to check
-- @return true if bound, false if not
function BindMap:is_bound(button)
    local b = self:get(button);
    if b == nil then
        return false;
    else
        return true;
    end
end

function BindMap:bind_hold(button, fn_id)
    if self:get_button(fn_id) then
        self:remove_binding(fn_id);
    end
    local b = self:get(button) or Binding:new();
    if self.hold[button] then return self; end
    local st_fn = nil;
    local fn = nil;
    -- TODO: add multiselect fns here
    if fn_id == 'deselect' then
        fn = deselect_all;
    elseif fn_id == 'sort_suit' then
        fn = sort_by_suit;
    elseif fn_id == 'sort_val' then
        fn = sort_by_value;
    elseif fn_id == 'play' then
        fn = play_hand;
    elseif fn_id == 'discard' then
        fn = discard_hand;
    elseif fn_id == 'restart' then
        fn = restart_game;
    end
    b:set_hold_start(st_fn);
    b:set_hold_end(fn);
    return self:insert(button, b, fn_id, true);
end

function BindMap:bind_click(button, fn_id)
    if self:get_button(fn_id) then
        self:remove_binding(fn_id);
    end
    local b = self:get(button) or Binding:new();
    if self.click[button] then return self; end
    local fn = nil;
    if fn_id == 'deselect' then
        fn = deselect_all;
    elseif fn_id == 'sort_suit' then
        fn = sort_by_suit;
    elseif fn_id == 'sort_val' then
        fn = sort_by_value;
    elseif fn_id == 'play' then
        fn = play_hand;
    elseif fn_id == 'discard' then
        fn = discard_hand;
    elseif fn_id == 'restart' then
        fn = restart_game;
    end
    b:set_click(fn);
    return self:insert(button, b, fn_id, false);
end
