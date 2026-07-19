-- Normalizes trusted FiveM identifier types while excluding IP addresses from durable identity.
local IdentifierService = {}

local priority = { 'license', 'license2', 'fivem', 'discord', 'steam', 'xbl', 'live' }
local priority_index = {}
for index, identifier_type in ipairs(priority) do
    priority_index[identifier_type] = index
end

local function trim(value)
    return value:match('^%s*(.-)%s*$')
end

---@param raw_identifiers table
---@return table?, string?
function IdentifierService.normalize(raw_identifiers)
    if type(raw_identifiers) ~= 'table' then
        return nil, 'IDENTIFIER_REQUIRED'
    end

    local unique = {}
    for _, raw in ipairs(raw_identifiers) do
        if type(raw) == 'string' then
            local identifier_type, identifier_value = raw:match('^([%w_]+):(.+)$')
            identifier_type = identifier_type and identifier_type:lower() or nil
            if identifier_type and priority_index[identifier_type] then
                identifier_value = trim(identifier_value):lower()
                if identifier_value ~= '' then
                    local normalized = identifier_type .. ':' .. identifier_value
                    unique[normalized] = {
                        type = identifier_type,
                        value = normalized,
                        hint = identifier_value:sub(-4),
                    }
                end
            end
        end
    end

    local identifiers = {}
    for _, identifier in pairs(unique) do
        identifiers[#identifiers + 1] = identifier
    end
    table.sort(identifiers, function(left, right)
        local left_priority = priority_index[left.type]
        local right_priority = priority_index[right.type]
        if left_priority == right_priority then
            return left.value < right.value
        end
        return left_priority < right_priority
    end)

    local primary = nil
    for _, identifier in ipairs(identifiers) do
        if identifier.type == 'license' or identifier.type == 'fivem' then
            primary = identifier
            break
        end
    end
    if not primary then
        return nil, 'IDENTIFIER_REQUIRED'
    end

    return { identifiers = identifiers, primary = primary }
end

return IdentifierService
