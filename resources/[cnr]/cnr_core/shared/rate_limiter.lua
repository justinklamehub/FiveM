-- Implements a small injected-clock fixed-window limiter for future request handlers.
local RateLimiter = {}
RateLimiter.__index = RateLimiter

---@param clock? fun(): integer
---@return table
function RateLimiter.new(clock)
    return setmetatable({
        buckets = {},
        clock = clock or function()
            return math.floor(os.clock() * 1000)
        end,
    }, RateLimiter)
end

---@param key string
---@param limit integer
---@param window_ms integer
---@return boolean, integer
function RateLimiter:consume(key, limit, window_ms)
    if limit < 1 or window_ms < 1 then
        return false, 0
    end
    local now = self.clock()
    local bucket = self.buckets[key]
    if not bucket or now >= bucket.reset_at then
        bucket = { count = 0, reset_at = now + window_ms }
        self.buckets[key] = bucket
    end
    if bucket.count >= limit then
        return false, math.max(0, bucket.reset_at - now)
    end
    bucket.count = bucket.count + 1
    return true, math.max(0, bucket.reset_at - now)
end

return RateLimiter
