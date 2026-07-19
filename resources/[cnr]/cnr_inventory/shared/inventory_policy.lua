-- Pure validation and capacity policy for the first personal-inventory slice.
local Policy = {}

local function is_uuid(value)
    return type(value) == 'string'
        and value:match(
                '^[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+$'
            )
            ~= nil
end

local function strict_keys(payload, allowed)
    for key in pairs(payload) do
        if not allowed[key] then
            return false
        end
    end
    return true
end

---@param payload unknown
---@return table?, string?
function Policy.validate_read(payload)
    if type(payload) ~= 'table' then
        return nil, 'VALIDATION_ERROR'
    end
    if not strict_keys(payload, { request_id = true, contract_version = true }) then
        return nil, 'VALIDATION_ERROR'
    end
    if
        payload.contract_version ~= 4
        or type(payload.request_id) ~= 'string'
        or #payload.request_id < 1
        or #payload.request_id > 64
    then
        return nil, 'VALIDATION_ERROR'
    end
    return payload
end

---@param payload unknown
---@return table?, string?
function Policy.validate_transfer(payload)
    if type(payload) ~= 'table' then
        return nil, 'VALIDATION_ERROR'
    end
    if
        not strict_keys(payload, {
            source_inventory_uuid = true,
            target_inventory_uuid = true,
            source_slot = true,
            target_slot = true,
            quantity = true,
            request_id = true,
            operation_uuid = true,
            contract_version = true,
        })
    then
        return nil, 'VALIDATION_ERROR'
    end
    if payload.contract_version ~= 4 then
        return nil, 'PRECONDITION_FAILED'
    end
    if
        not is_uuid(payload.source_inventory_uuid)
        or not is_uuid(payload.target_inventory_uuid)
        or payload.source_inventory_uuid == payload.target_inventory_uuid
        or not is_uuid(payload.operation_uuid)
        or type(payload.request_id) ~= 'string'
        or #payload.request_id < 1
        or #payload.request_id > 64
        or type(payload.source_slot) ~= 'number'
        or payload.source_slot % 1 ~= 0
        or payload.source_slot < 1
        or type(payload.target_slot) ~= 'number'
        or payload.target_slot % 1 ~= 0
        or payload.target_slot < 1
        or type(payload.quantity) ~= 'number'
        or payload.quantity % 1 ~= 0
        or payload.quantity < 1
    then
        return nil, 'VALIDATION_ERROR'
    end
    return payload
end

---@param payload unknown
---@return table?, string?
function Policy.validate_reposition(payload)
    if type(payload) ~= 'table' then
        return nil, 'VALIDATION_ERROR'
    end
    if
        not strict_keys(payload, {
            inventory_uuid = true,
            source_slot = true,
            target_slot = true,
            request_id = true,
            operation_uuid = true,
            contract_version = true,
        })
    then
        return nil, 'VALIDATION_ERROR'
    end
    if payload.contract_version ~= 4 then
        return nil, 'PRECONDITION_FAILED'
    end
    if
        not is_uuid(payload.inventory_uuid)
        or not is_uuid(payload.operation_uuid)
        or type(payload.request_id) ~= 'string'
        or #payload.request_id < 1
        or #payload.request_id > 64
        or type(payload.source_slot) ~= 'number'
        or payload.source_slot % 1 ~= 0
        or payload.source_slot < 1
        or type(payload.target_slot) ~= 'number'
        or payload.target_slot % 1 ~= 0
        or payload.target_slot < 1
        or payload.source_slot == payload.target_slot
    then
        return nil, 'VALIDATION_ERROR'
    end
    return payload
end

---@param source_type string
---@param target_type string
---@return boolean
function Policy.is_personal_storage_pair(source_type, target_type)
    return (source_type == 'CHARACTER' and target_type == 'PERSONAL_STORAGE')
        or (source_type == 'PERSONAL_STORAGE' and target_type == 'CHARACTER')
end

---@param player table
---@param locker table
---@param radius number
---@return boolean
function Policy.within_access_radius(player, locker, radius)
    if
        type(player) ~= 'table'
        or type(locker) ~= 'table'
        or type(player.x) ~= 'number'
        or type(player.y) ~= 'number'
        or type(player.z) ~= 'number'
        or type(locker.x) ~= 'number'
        or type(locker.y) ~= 'number'
        or type(locker.z) ~= 'number'
        or type(radius) ~= 'number'
        or radius <= 0
    then
        return false
    end
    local x = player.x - locker.x
    local y = player.y - locker.y
    local z = player.z - locker.z
    return x * x + y * y + z * z <= radius * radius
end

---@param entries table[]
---@param capacity number
---@return number?
function Policy.first_free_slot(entries, capacity)
    local occupied = {}
    for _, entry in ipairs(entries) do
        occupied[tonumber(entry.slot_number)] = true
    end
    for slot = 1, capacity do
        if not occupied[slot] then
            return slot
        end
    end
    return nil
end

---@param context table
---@return table?, string?
function Policy.transfer_plan(context)
    local source = context.source_entry
    local definition = source and source.definition
    local target = context.target_entry
    if not source or not definition or context.quantity > tonumber(source.quantity) then
        return nil, 'INSUFFICIENT_QUANTITY'
    end
    if
        context.target_weight_grams + context.quantity * definition.unit_weight_grams
        > context.target_inventory.weight_capacity_grams
    then
        return nil, 'INSUFFICIENT_CAPACITY'
    end
    if context.target_slot < 1 or context.target_slot > context.target_inventory.slot_capacity then
        return nil, 'PRECONDITION_FAILED'
    end
    if definition.is_unique then
        if context.quantity ~= 1 or not source.has_instance or target then
            return nil, 'PRECONDITION_FAILED'
        end
        return { mode = 'MOVE_INSTANCE', target_slot = context.target_slot }
    end
    if not definition.is_stackable or source.has_instance then
        return nil, 'PRECONDITION_FAILED'
    end
    if target then
        if
            target.definition_id ~= source.definition_id
            or target.has_instance
            or target.quantity + context.quantity > definition.max_stack
        then
            return nil, 'PRECONDITION_FAILED'
        end
        return { mode = 'STACK', target_slot = context.target_slot }
    end
    if context.quantity > definition.max_stack then
        return nil, 'INSUFFICIENT_CAPACITY'
    end
    return { mode = 'CREATE_STACK', target_slot = context.target_slot }
end

---@param context table
---@return table?, string?
function Policy.reposition_plan(context)
    local inventory = context.inventory
    local source = context.source_entry
    if
        not inventory
        or not source
        or context.source_slot ~= source.slot_number
        or context.source_slot > inventory.slot_capacity
        or context.target_slot > inventory.slot_capacity
        or context.source_slot == context.target_slot
    then
        return nil, 'PRECONDITION_FAILED'
    end
    if context.target_entry then
        return {
            mode = 'SWAP',
            source_slot = context.source_slot,
            target_slot = context.target_slot,
            temporary_slot = inventory.slot_capacity + 1,
        }
    end
    return {
        mode = 'MOVE',
        source_slot = context.source_slot,
        target_slot = context.target_slot,
    }
end

return Policy
