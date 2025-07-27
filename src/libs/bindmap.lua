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
    click_hold_threshold = 8,
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
function BindMap:insert(button, binding)
    self.button_to_binding[button] = binding;
    self.binding_to_button[binding] = button;
    return self;
end

--- Gets the associated @{Binding} for a button.
--
-- @param button the keycode to query
-- @return the queried @{Binding}, or nil
function BindMap:get(button)
    return self.button_to_binding[button];
end

--- Gets the associated button for a @{Binding}.
--
-- @param binding the @{Binding} to query
-- @return the queried button, or nil
function BindMap:get_button(binding)
    return self.binding_to_button[binding];
end

--- Clears the @{Binding} from a given button.
-- Clears the @{Binding} from a given button, regardless of bound @{Binding}.
--
-- @param button the keycode to clear the @{Binding} for
-- @return the @{BindMap} instance for chain-calling
function BindMap:clear(button)
    local binding = self.button_to_binding[button];
    self.button_to_binding[button] = nil;
    self.binding_to_button[binding] = nil;
    return self;
end

--- Clears the button from a given @{Binding}.
-- Clears the button from a given @{Binding}, regardless of bound button.
--
-- @param binding the @{Binding} to clear the button for
-- @return the @{BindMap} instance for chain-calling
function BindMap:clear_binding(binding)
    local button = self.binding_to_button[binding];
    self.button_to_binding[button] = nil;
    self.binding_to_button[binding] = nil;
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
