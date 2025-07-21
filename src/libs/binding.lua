--- Represents how a key is bound.
--
-- @field click_fn Option<Fn(x, y, button, touch)>
-- @field hold_fn Option<Fn(x, y, button, touch)>
Binding = {
    click_fn = nil,
    hold_fn = nil,
};

--- Creates a new @{Binding}.
--
--  @param click_fn Option<Fn(x, y, button, touch)>
--  @param hold_fn Option<Fn(x, y, button, touch)>
--  @return the new @{Binding}
function Binding:new(click_fn, hold_fn)
    local b = {
        click_fn = click_fn,
        hold_fn = hold_fn,
    };
    setmetatable(b, self);
    self.__index = self;
    return b;
end

--- Runs the bound `click_fn`.
-- Runs the bound `click_fn`, throwing an error if a function isn't bound.
--
-- @param x the mouse x coordinate or `nil`
-- @param y the mouse y coordinate or `nil`
-- @param button the keycode for the button clicked
-- @param istouch boolean indicating whether touchscreen sent signal
-- @return the @{Binding} instance for chain-calling
function Binding:click(x, y, button, istouch)
    if self.click_fn == nil then
        error('attempted to click a binding without a click function');
    end
    self.click_fn(x, y, button, istouch);
    return self;
end

--- Sets the bound `click_fn`.
-- @param click_fn the function to call when clicked
-- @return the @{Binding} instance for chain-calling
function Binding:set_click(click_fn)
    self.click_fn = click_fn;
    return self;
end

--- Unsets the bound `click_fn`.
-- @return the @{Binding} instance for chain-calling
function Binding:unset_click()
    self.click_fn = nil;
    return self;
end

--- Runs the bound `hold_fn`.
-- Runs the bound `hold_fn`, throwing an error if a function isn't bound.
--
-- @param x the mouse x coordinate or `nil`
-- @param y the mouse y coordinate or `nil`
-- @param button the keycode for the button held
-- @param istouch boolean indicating whether touchscreen sent signal
-- @return the @{Binding} instance for chain-calling
function Binding:hold(x, y, button, istouch)
    if self.hold_fn == nil then
        error('attempted to hold a binding without a hold function');
    end
    self.hold_fn(x, y, button, istouch);
    return self;
end

--- Sets the bound `hold_fn`.
-- @param hold_fn the function to call when held
-- @return the @{Binding} instance for chain-calling
function Binding:set_hold(hold_fn)
    self.hold_fn = hold_fn;
    return self;
end

--- Unsets the bound `hold_fn`.
-- @return the @{Binding} instance for chain-calling
function Binding:unset_hold()
    self.hold_fn = nil;
    return self;
end
