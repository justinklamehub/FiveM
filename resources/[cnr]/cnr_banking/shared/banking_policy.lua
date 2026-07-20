-- Validates the deliberately narrow read-only banking contract.
local Policy = { contract_version = 1 }

local function has_exact_keys(value, allowed)
    local count = 0
    for key in pairs(value) do
        if not allowed[key] then
            return false
        end
        count = count + 1
    end
    return count == 2
end

function Policy.validate_snapshot(payload)
    if type(payload) ~= 'table' then
        return nil, 'payload'
    end
    if not has_exact_keys(payload, { request_id = true, contract_version = true }) then
        return nil, 'fields'
    end
    if
        type(payload.request_id) ~= 'string'
        or payload.request_id == ''
        or #payload.request_id > 96
    then
        return nil, 'request_id'
    end
    if payload.contract_version ~= Policy.contract_version then
        return nil, 'contract_version'
    end
    return {
        request_id = payload.request_id,
        contract_version = payload.contract_version,
    }
end

function Policy.normalize_account(row)
    local balance = tonumber(row.balance_minor)
    local version = tonumber(row.version)
    if
        type(row.account_uuid) ~= 'string'
        or type(row.account_number) ~= 'string'
        or (row.account_type ~= 'CASH_WALLET' and row.account_type ~= 'PERSONAL_CHECKING')
        or row.currency ~= 'USD'
        or type(row.status) ~= 'string'
        or not balance
        or not version
    then
        return nil
    end
    return {
        account_uuid = row.account_uuid,
        account_number = row.account_number,
        account_type = row.account_type,
        currency = row.currency,
        status = row.status,
        balance_minor = balance,
        version = version,
    }
end

return Policy
