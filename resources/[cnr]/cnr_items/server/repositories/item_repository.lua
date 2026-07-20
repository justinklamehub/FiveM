-- Reads the active item catalogue; cnr_items is the sole writer of definition state.
local Repository = {}
local uuid = [[LOWER(INSERT(INSERT(INSERT(INSERT(HEX(%s),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))]]

local columns = ([[%s definition_uuid, code, category, label, description, icon_key, is_stackable,
is_unique, max_stack, unit_weight_grams, is_tradeable, is_drop_allowed, use_handler,
metadata_schema_version, version]]):format(uuid:format('public_uuid'))

function Repository.list_active()
    local result = exports.cnr_database:query(
        ("SELECT %s FROM cnr_item_definitions WHERE status='ACTIVE' ORDER BY category, code"):format(
            columns
        )
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.find_active(code)
    local result = exports.cnr_database:single(
        ("SELECT %s FROM cnr_item_definitions WHERE code=? AND status='ACTIVE' LIMIT 1"):format(
            columns
        ),
        { code }
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

return Repository
