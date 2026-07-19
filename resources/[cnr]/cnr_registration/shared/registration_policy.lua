-- Pure registration validation and server-side whitelist transition policy.
local RegistrationPolicy = {}

---@param value unknown
---@return boolean
function RegistrationPolicy.is_uuid(value)
    return type(value) == 'string'
        and value:match(
                '^[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+$'
            )
            ~= nil
end

---@param payload table
---@return table?, string?
function RegistrationPolicy.validate(payload)
    if type(payload) ~= 'table' then
        return nil, 'VALIDATION_ERROR'
    end
    local allowed = {
        ruleset_uuid = true,
        ruleset_version = true,
        acceptance = true,
        locale = true,
        request_id = true,
        operation_uuid = true,
        contract_version = true,
    }
    for key in pairs(payload) do
        if not allowed[key] then
            return nil, 'VALIDATION_ERROR'
        end
    end
    if payload.contract_version ~= 1 then
        return nil, 'PRECONDITION_FAILED'
    end
    if
        not RegistrationPolicy.is_uuid(payload.ruleset_uuid)
        or not RegistrationPolicy.is_uuid(payload.operation_uuid)
        or type(payload.ruleset_version) ~= 'number'
        or payload.ruleset_version % 1 ~= 0
        or payload.acceptance ~= true
        or payload.locale ~= 'en'
        or type(payload.request_id) ~= 'string'
        or #payload.request_id < 1
        or #payload.request_id > 64
    then
        return nil, 'VALIDATION_ERROR'
    end
    return payload
end

---@param mode string
---@param has_entry boolean
---@return table
function RegistrationPolicy.transition(mode, has_entry)
    if mode == 'manual' then
        if has_entry then
            return { account_status = 'ACTIVE', access_state = 'FULL' }
        end
        return { account_status = 'PENDING_WHITELIST', access_state = 'LIMITED' }
    end
    if mode == 'hybrid' and not has_entry then
        return { account_status = 'PENDING_WHITELIST', access_state = 'LIMITED' }
    end
    return { account_status = 'ACTIVE', access_state = 'FULL' }
end

return RegistrationPolicy
