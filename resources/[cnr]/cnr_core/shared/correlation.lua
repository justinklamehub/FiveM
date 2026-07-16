-- Creates diagnostic correlation IDs for logs and standardized results.
local Correlation = {}
local counter = 0

---@param now_ms? fun(): integer
---@param random_value? fun(): integer
---@return string
function Correlation.create(now_ms, random_value)
    counter = counter + 1
    local timestamp = now_ms and now_ms() or math.floor(os.time() * 1000)
    local entropy = random_value and random_value() or math.random(0, 0xFFFFFF)
    return ('corr-%013d-%06x-%06x'):format(timestamp, counter % 0xFFFFFF, entropy % 0xFFFFFF)
end

return Correlation
