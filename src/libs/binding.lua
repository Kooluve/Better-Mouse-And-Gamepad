--- Represents how a key is bound.
--
-- @field click_fn Option<Fn(x, y, button, touch)>
-- @field hold_fn Option<Fn(x, y, button, touch)>
Binding = {
    click_fn = nil,
    hold_start_fn = nil,
    hold_end_fn = nil,
};

--- Creates a new @{Binding}.
--
--  @param click_fn Option<Fn(x, y, button, touch)>
--  @param hold_fn Option<Fn(x, y, button, touch)>
--  @return the new @{Binding}
function Binding:new()
    local b = {
        click_fn = nil,
        hold_start_fn = nil,
        hold_end_fn = nil,
    };
    setmetatable(b, self);
    self.__index = self;
    return b;
end

--- Runs the bound `click_fn`.
-- Runs the bound `click_fn`, throwing an error if a function isn't bound.
--
-- @return the @{Binding} instance for chain-calling
function Binding:click()
    if self.click_fn == nil then
        return self;
    end
    self.click_fn();
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

--- Runs the bound `hold_start_fn`.
-- Runs the bound `hold_start_fn`, throwing an error if a function isn't bound.
--
-- @return the @{Binding} instance for chain-calling
function Binding:hold_start()
    if self.hold_start_fn == nil then
        return self;
    end
    self.hold_start_fn();
    return self;
end

--- Sets the bound `hold_start_fn`.
-- @param hold_start_fn the function to call when held
-- @return the @{Binding} instance for chain-calling
function Binding:set_hold_start(hold_start_fn)
    self.hold_start_fn = hold_start_fn;
    return self;
end

--- Unsets the bound `hold_start_fn`.
-- @return the @{Binding} instance for chain-calling
function Binding:unset_hold_start()
    self.hold_start_fn = nil;
    return self;
end

--- Runs the bound `hold_end_fn`.
-- Runs the bound `hold_end_fn`, throwing an error if a function isn't bound.
--
-- @param x the mouse x coordinate or `nil`
-- @param y the mouse y coordinate or `nil`
-- @param button the keycode for the button held
-- @param istouch boolean indicating whether touchscreen sent signal
-- @return the @{Binding} instance for chain-calling
function Binding:hold_end()
    if self.hold_end_fn == nil then
        return self;
    end
    self.hold_end_fn();
    return self;
end

--- Sets the bound `hold_end_fn`.
-- @param hold_end_fn the function to call when held
-- @return the @{Binding} instance for chain-calling
function Binding:set_hold_end(hold_end_fn)
    self.hold_end_fn = hold_end_fn;
    return self;
end

--- Unsets the bound `hold_end_fn`.
-- @return the @{Binding} instance for chain-calling
function Binding:unset_hold_end()
    self.hold_end_fn = nil;
    return self;
end

function Binding:is_click_bound()
    if self.click_fn then
        return true;
    else
        return false;
    end
end

function Binding:is_hold_bound()
    if
        self.hold_start_fn
        or self.hold_end_fn
    then
        return true;
    else
        return false;
    end
end
