Queue = {}
--[[
    Queue<_>:new(q: {}) -> Queue<_>

    Creates a new Queue, adding given values if provided.

    Example:
    local q = Queue:new()   -- creates new empty Queue
    local q = Queue:new({   -- creates populated Queue
        [1] = "test",
        first = 1,
        last = 1,
    })
--]]
function Queue:new(q)
    local q = q or {
        first = 1,
        last = 1,
    };
    setmetatable(q, self);
    self.__index = self;
    return q;
end

--[[
    Queue<E>:push(e: E) -> nil

    Pushes to the end of the Queue.

    Overflows at 1.8446744e+19, and unless someone leaves Balatro open for an entire
    millenium, this is unlikely to be reached. Might implement anti-overflow logic
    in a later release.

    TODO: Fix overflow bug by limiting the max position, resetting and copying
    to a new memory table upon exceeding the threshold.
--]]
function Queue:push(v)
    local last = self.last + 1;
    self.last = last;
    self[last] = v;
end

--[[
    Queue<E>:pop() -> Option<E>

    Pops from the start of the Queue. Sets the old entry to `nil`, then increments
    the `first` position.
--]]
function Queue:pop()
    local first = self.first;
    if first > self.last then
        return nil;
    end
    local v = self[first];
    self[first] = nil;
    self.first = first + 1;
    return v;
end

local q = Queue:new({
    [1] = "test",
    first = 1,
    last = 1,
});
local size = (q.last - q.first) + 1;
print("Size (empty): " .. size);

print("Pushing test values...");
q:push("test1");
q:push("test2");
q:push("test3");

size = (q.last - q.first) + 1;
print("Size (filled): " .. size);

print("Popping test values...");
if size <= 0 then error("queue is still empty uh oh") end
for i = q.first, size, 1 do
    local r = q:pop();
    if r == nil then
        print(i .. ": nil");
    else
        print(i .. ": " .. r);
    end
end

size = (q.last - q.first) + 1;
print("Size (popped): " .. size);

if q:pop() == nil then
    print("Attempting to pop further returns `nil`.")
end
