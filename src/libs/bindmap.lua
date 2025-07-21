--[[
    BindMap

    Contains all custom binds set by the mod. Used to determine whether or not
    to fallback to the standard Love2D event handling. Uses 2 maps, one for each
    association direction to make lookup much faster.

    Binds a button code to a Lua function.
--]]
BindMap = {
    button_to_feature = {},
    feature_to_button = {},
};

--[[
    BindMap:new() -> Self

    Creates a new BindMap; should only be run once during runtime.
--]]
function BindMap:new()
    local im = {
        button_to_feature = {},
        feature_to_button = {},
    };
    setmetatable(im, self);
    self.__index = self;
    return im;
end

--[[
    BindMap:insert(button: KeyCode, feature: Feature) -> Self

    Inserts a binding to a given feature into the input map.
--]]
function BindMap:insert(button, feature)
    self.button_to_feature[button] = feature;
    self.feature_to_button[feature] = button;
    return self;
end

--[[
    BindMap:get(button: KeyCode) -> Option<Feature>

    Gets the associated feature for a button.
--]]
function BindMap:get(button)
    return self.button_to_feature[button];
end

--[[
    BindMap:get_button(feature: Feature) -> Option<KeyCode>

    Gets the associated button for a feature.
--]]
function BindMap:get_button(feature)
    return self.feature_to_button[feature];
end

--[[
    BindMap:clear_button(button: KeyCode)

    Clears the association to a given button (regardless of bound feature).
--]]
function BindMap:clear_button(button)
    local feature = self.button_to_feature[button];
    self.button_to_feature[button] = nil;
    self.feature_to_button[feature] = nil;
    return self;
end

--[[
    BindMap:clear_feature(feature: Feature)

    Clears the association to a given feature (regardless of bound button).
--]]
function BindMap:clear_feature(feature)
    local button = self.feature_to_button[feature];
    self.button_to_feature[button] = nil;
    self.feature_to_button[feature] = nil;
    return self;
end
