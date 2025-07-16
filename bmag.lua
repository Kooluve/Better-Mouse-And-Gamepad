--- STEAMODDED HEADER
--- MOD_NAME: Better Mouse And Gamepad
--- MOD_ID: BetterMouseAndGamepad
--- MOD_AUTHOR: [uptu, Kooluve]
--- MOD_DESCRIPTION: Makes the mouse and gamepad controls more easy and efficient to use. Among other features, allows the selection of multiple cards and rebinding common actions.
--- PRIORITY: -10000
--- PREFIX: bmag_v2
--- VERSION: 2.0.0

------------------
-- GLOBAL STATE --
------------------
-- put any and all mutable state in here. we don't need 3 different state types...
--
-- `timers`:
--     Monotonic int clock table; increments by 1 each frame during keypress, so not
--     real-time. Lua's table library should do most of the heavy lifting. Used to
--     determine if a keypress is a held or clicked key. If the timer passes a user's
--     set threshold, it is a hold event, else it is a click. Effectively clicks are
--     handled upon keyrelease, while holds start handling a given threshold after
--     keypress.
--
--     Example
--     ~~~~~~~
--     timers[button] += 1      -- done on every update loop for click/hold processing
--     if
--         timers[button] != nil and
--         timers[button] >= threshold
--     then
--         -- handle input as key hold and not keypress
--     end
--
-- `queue`:
--     A simple FIFO queue containing all of the unhandled bound keypresses and releases.
--     One entry is removed every frame, preventing engine lockup from excessive input.
--
--     Example
--     ~~~~~~~
--     table.insert(queue, SomeKeyPressObjectInstance)      -- insert at end
--     table.remove(queue, 1)                               -- pop from front

STATE = {
    timers = {},
    queue = {},
}
