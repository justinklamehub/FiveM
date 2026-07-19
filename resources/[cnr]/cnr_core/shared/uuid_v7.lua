-- Generates sortable UUIDv7 values without treating them as authentication secrets.
local UuidV7 = {}
local last_timestamp = -1
local sequence = 0

local function default_now_ms()
    return math.floor(os.time() * 1000)
end

local function default_random_16()
    return math.random(0, 0xFFFF)
end

---@param now_ms? fun(): integer
---@param random_16? fun(): integer
---@return string
function UuidV7.create(now_ms, random_16)
    local timestamp = (now_ms or default_now_ms)()
    if timestamp < last_timestamp then
        timestamp = last_timestamp
    end

    if timestamp == last_timestamp then
        sequence = (sequence + 1) & 0x0FFF
        if sequence == 0 then
            timestamp = timestamp + 1
        end
    else
        sequence = 0
    end
    last_timestamp = timestamp

    local random = random_16 or default_random_16
    local timestamp_hex = ('%012x'):format(timestamp & 0xFFFFFFFFFFFF)
    local version_and_sequence = 0x7000 | sequence
    local variant_and_random = 0x8000 | (random() & 0x3FFF)
    local random_tail = ('%04x%04x%04x'):format(
        random() & 0xFFFF,
        random() & 0xFFFF,
        random() & 0xFFFF
    )

    return ('%s-%s-%04x-%04x-%s'):format(
        timestamp_hex:sub(1, 8),
        timestamp_hex:sub(9, 12),
        version_and_sequence,
        variant_and_random,
        random_tail
    )
end

return UuidV7
