--[[
    InputMap

    Contains all custom binds set by the mod. Used to determine whether or not
    to fallback to the standard Love2D event handling. Uses 2 maps, one for each
    association direction to make lookup much faster.

    Binds a button code to a Lua function.
--]]
InputMap = {
    button_to_feature = {},
    feature_to_button = {},
};

--[[
    InputMap:new() -> Self

    Creates a new InputMap; should only be run once during runtime.
--]]
function InputMap:new()
    local im = {
        button_to_feature = {},
        feature_to_button = {},
    };
    setmetatable(im, self);
    self.__index = self;
    return im;
end

--[[
    InputMap:insert(button: KeyCode, feature: Feature) -> Self

    Inserts a binding to a given feature into the input map.
--]]
function InputMap:insert(button, feature)
    self.button_to_feature[button] = feature;
    self.feature_to_button[feature] = button;
    return self;
end

--[[
    InputMap:get(button: KeyCode) -> Option<Feature>

    Gets the associated feature for a button.
--]]
function InputMap:get(button)
    return self.button_to_feature[button];
end

--[[
    InputMap:get_button(feature: Feature) -> Option<KeyCode>

    Gets the associated button for a feature.
--]]
function InputMap:get_button(feature)
    return self.feature_to_button[feature];
end

--[[
    InputMap:clear_button(button: KeyCode)

    Clears the association to a given button (regardless of bound feature).
--]]
function InputMap:clear_button(button)
    local feature = self.button_to_feature[button];
    self.button_to_feature[button] = nil;
    self.feature_to_button[feature] = nil;
    return self;
end

--[[
    InputMap:clear_feature(feature: Feature)

    Clears the association to a given feature (regardless of bound button).
--]]
function InputMap:clear_feature(feature)
    local button = self.feature_to_button[feature];
    self.button_to_feature[button] = nil;
    self.feature_to_button[feature] = nil;
    return self;
end
