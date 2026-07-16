-- Normalizes technical permission, role, and audit reason identifiers.
local PermissionIdentifier = {}

local function trim(value)
    return value:match('^%s*(.-)%s*$')
end

local function normalize(value, maximum_length)
    if type(value) ~= 'string' then
        return nil
    end

    local normalized = trim(value):lower()
    if normalized == '' or #normalized > maximum_length then
        return nil
    end

    return normalized
end

---@param value unknown
---@return string?
function PermissionIdentifier.permission(value)
    local normalized = normalize(value, 96)
    if not normalized then
        return nil
    end

    if normalized:sub(1, 1) == '.' or normalized:sub(-1) == '.' then
        return nil
    end
    if normalized:find('..', 1, true) then
        return nil
    end
    if not normalized:match('^[a-z][a-z0-9_]*%.[a-z][a-z0-9_%.]*$') then
        return nil
    end

    return normalized
end

---@param value unknown
---@return string?
function PermissionIdentifier.role(value)
    local normalized = normalize(value, 64)
    if not normalized or not normalized:match('^[a-z][a-z0-9_]*$') then
        return nil
    end
    return normalized
end

---@param value unknown
---@param fallback? string
---@return string?
function PermissionIdentifier.reason(value, fallback)
    local candidate = value
    if candidate == nil or candidate == '' then
        candidate = fallback
    end

    local normalized = normalize(candidate, 96)
    if not normalized then
        return nil
    end
    if normalized:sub(1, 1) == '.' or normalized:sub(-1) == '.' then
        return nil
    end
    if normalized:find('..', 1, true) then
        return nil
    end
    if not normalized:match('^[a-z][a-z0-9_%.%-]*$') then
        return nil
    end

    return normalized
end

return PermissionIdentifier
