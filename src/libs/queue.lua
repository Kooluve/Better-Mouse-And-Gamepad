--- queue.lua
--
--  This file contains the @{Queue} object.

--- A simple FIFO queue that can hold anything.
-- A simple FIFO queue that won't overflow for at least 200 years of runtime.
Queue = {};

--- Create a new @{Queue}
-- Create a new @{Queue}, adding given values if provided.
--
-- Example:
-- local q = Queue:new()   -- creates new empty Queue
-- local q = Queue:new({   -- creates populated Queue
--     [1] = "test",
--     first = 1,
--     last = 1,
-- })
--
-- @param q optional populated @{Queue} instance
-- @return the new @{Queue}
function Queue:new(q)
    local q = q or {
        first = 1,
        last = 0,
    };
    setmetatable(q, self);
    self.__index = self;
    return q;
end

--- Pushes to the end of the Queue.
-- Overflows at 1.8446744e+19, and unless someone leaves Balatro open for an entire
-- millenium, this is unlikely to be reached. Might implement anti-overflow logic
-- in a later release.
--
-- TODO: Fix overflow bug by limiting the max position, resetting and copying
-- to a new memory table upon exceeding the threshold.
--
-- @param v the value to push
-- @return the @{Queue} instance for chain-calling
function Queue:push(v)
    self.last = self.last + 1;
    self[self.last] = v;
    return self;
end

--- Pops from the start of the Queue.
-- Pops from the queue by setting the old entry to `nil`, then incrementing the
-- `first` position.
--
-- @return the popped value
function Queue:pop()
    if self.first > self.last then
        return nil;
    end
    local v = self[self.first];
    self[self.first] = nil;
    self.first = self.first + 1;
    return v;
end
