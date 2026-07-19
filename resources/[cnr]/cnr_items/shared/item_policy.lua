-- Validates stable item-definition identifiers without database or FiveM dependencies.
local Policy = {}

---@param value unknown
---@return boolean
function Policy.is_code(value)
    return type(value) == 'string'
        and #value >= 2
        and #value <= 64
        and value:match('^[a-z][a-z0-9_]+$') ~= nil
end

---@param row table
---@return table
function Policy.definition(row)
    return {
        definition_uuid = row.definition_uuid,
        code = row.code,
        category = row.category,
        label = row.label,
        description = row.description,
        icon_key = row.icon_key,
        is_stackable = tonumber(row.is_stackable) == 1,
        is_unique = tonumber(row.is_unique) == 1,
        max_stack = tonumber(row.max_stack),
        unit_weight_grams = tonumber(row.unit_weight_grams),
        is_tradeable = tonumber(row.is_tradeable) == 1,
        is_drop_allowed = tonumber(row.is_drop_allowed) == 1,
        use_handler = row.use_handler,
        metadata_schema_version = tonumber(row.metadata_schema_version),
        version = tonumber(row.version),
    }
end

return Policy
