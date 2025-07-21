--[[
    Binding

    Represents how a key is bound

    @field press_fn: Option<Fn(x, y, button, touch)>
    @field release_fn: Option<Fn(x, y, button, touch)>
--]]
Binding = {
    press_fn = nil,
    release_fn = nil,
};

--[[
    Binding:new()

    Creates a new Binding

    @param press_fn: Option<Fn(x, y, button, touch)>
    @param release_fn: Option<Fn(x, y, button, touch)>
    @return Binding
--]]
function Binding:new(press_fn, release_fn)
    local b = {
        press_fn = press_fn,
        release_fn = release_fn,
    };
    setmetatable(b, self);
    self.__index = self;
    return b;
end

--[[
    Binding:press()

    Runs the bound `press_fn`, throwing an error if a function isn't bound
    Also starts the timer for the corresponding keypress

    @param x: the mouse x coordinate or `nil`
    @param y: the mouse y coordinate or `nil`
    @param button: the keycode for the button pressed
    @param touch: idrk what this does yet; touchpad stuff?
    @return self
--]]
function Binding:press(x, y, button, touch)
    if self.press_fn == nil then
        error('attempted to press a binding without a press function');
    end
    STATE.timers:start(button);
    self.press_fn(x, y, button, touch);
    return self;
end

function Binding:set_press(press_fn)
    self.press_fn = press_fn;
    return self;
end

function Binding:unset_press()
    self.press_fn = nil;
    return self;
end

--[[
    Binding:release()

    Runs the bound `release_fn`, throwing an error if a function isn't bound

    @param x: the mouse x coordinate or `nil`
    @param y: the mouse y coordinate or `nil`
    @param button: the keycode for the button pressed
    @param touch: idrk what this does yet; touchpad stuff?
    @return self
--]]
function Binding:release(x, y, button, touch)
    if self.release_fn == nil then
        error('attempted to release a binding without a release function');
    end
    STATE.timers:stop(button);
    self.release_fn(x, y, button, touch);
    return self;
end

function Binding:set_release(release_fn)
    self.release_fn = release_fn;
    return self;
end

function Binding:unset_release()
    self.release_fn = nil;
    return self;
end
