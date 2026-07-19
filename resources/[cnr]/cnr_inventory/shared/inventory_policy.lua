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
        payload.contract_version ~= 2
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
            quantity = true,
            request_id = true,
            operation_uuid = true,
            contract_version = true,
        })
    then
        return nil, 'VALIDATION_ERROR'
    end
    if payload.contract_version ~= 2 then
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
    if payload.contract_version ~= 2 then
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
    if not source or not definition or context.quantity > tonumber(source.quantity) then
        return nil, 'INSUFFICIENT_QUANTITY'
    end
    if
        context.target_weight_grams + context.quantity * definition.unit_weight_grams
        > context.target_inventory.weight_capacity_grams
    then
        return nil, 'INSUFFICIENT_CAPACITY'
    end
    if definition.is_unique then
        if context.quantity ~= 1 or not source.has_instance then
            return nil, 'PRECONDITION_FAILED'
        end
        local slot =
            Policy.first_free_slot(context.target_entries, context.target_inventory.slot_capacity)
        if not slot then
            return nil, 'INSUFFICIENT_CAPACITY'
        end
        return { mode = 'MOVE_INSTANCE', target_slot = slot }
    end
    if not definition.is_stackable or source.has_instance then
        return nil, 'PRECONDITION_FAILED'
    end
    if context.target_stack then
        if context.target_stack.quantity + context.quantity > definition.max_stack then
            return nil, 'INSUFFICIENT_CAPACITY'
        end
        return { mode = 'STACK', target_slot = context.target_stack.slot_number }
    end
    if context.quantity > definition.max_stack then
        return nil, 'INSUFFICIENT_CAPACITY'
    end
    local slot =
        Policy.first_free_slot(context.target_entries, context.target_inventory.slot_capacity)
    if not slot then
        return nil, 'INSUFFICIENT_CAPACITY'
    end
    return { mode = 'CREATE_STACK', target_slot = slot }
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
