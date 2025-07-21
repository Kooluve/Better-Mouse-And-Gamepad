--[[
    BindMap

    Contains all custom binds set by the mod. Used to determine whether or not
    to fallback to the standard Love2D event handling. Uses 2 maps, one for each
    association direction to make lookup much faster.

    Binds a button code to a Lua function.
--]]
BindMap = {
    button_to_binding = {},
    binding_to_button = {},
};

--[[
    BindMap:new() -> Self

    Creates a new BindMap; should only be run once during runtime.
--]]
function BindMap:new()
    local im = {
        button_to_binding = {},
        binding_to_button = {},
    };
    setmetatable(im, self);
    self.__index = self;
    return im;
end

--[[
    BindMap:insert(button: KeyCode, binding: Binding) -> Self

    Inserts a binding to a given binding into the input map.
--]]
function BindMap:insert(button, binding)
    self.button_to_binding[button] = binding;
    self.binding_to_button[binding] = button;
    return self;
end

--[[
    BindMap:get(button: KeyCode) -> Option<Binding>

    Gets the associated binding for a button.
--]]
function BindMap:get(button)
    return self.button_to_binding[button];
end

--[[
    BindMap:get_button(binding: Binding) -> Option<KeyCode>

    Gets the associated button for a binding.
--]]
function BindMap:get_button(binding)
    return self.binding_to_button[binding];
end

--[[
    BindMap:clear_button(button: KeyCode)

    Clears the association to a given button (regardless of bound binding).
--]]
function BindMap:clear_button(button)
    local binding = self.button_to_binding[button];
    self.button_to_binding[button] = nil;
    self.binding_to_button[binding] = nil;
    return self;
end

--[[
    BindMap:clear_binding(binding: Binding)

    Clears the association to a given binding (regardless of bound button).
--]]
function BindMap:clear_binding(binding)
    local button = self.binding_to_button[binding];
    self.button_to_binding[button] = nil;
    self.binding_to_button[binding] = nil;
    return self;
end
