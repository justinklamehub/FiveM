-- Validates narrow banking intents without accepting sender or ledger authority.
local Policy = { contract_version = 2 }

local uuid_pattern = '^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$'

local function has_exact_keys(value, allowed, expected_count)
    local count = 0
    for key in pairs(value) do
        if not allowed[key] then
            return false
        end
        count = count + 1
    end
    return count == expected_count
end

function Policy.validate_snapshot(payload)
    if type(payload) ~= 'table' then
        return nil, 'payload'
    end
    if not has_exact_keys(payload, { request_id = true, contract_version = true }, 2) then
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

function Policy.validate_transfer(payload)
    if type(payload) ~= 'table' then
        return nil, 'payload'
    end
    if
        not has_exact_keys(payload, {
            recipient_account_number = true,
            amount_minor = true,
            purpose = true,
            request_id = true,
            operation_uuid = true,
            contract_version = true,
        }, 6)
    then
        return nil, 'fields'
    end
    if
        type(payload.recipient_account_number) ~= 'string'
        or not payload.recipient_account_number
            :upper()
            :match('^SA%-%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$')
    then
        return nil, 'recipient_account_number'
    end
    if
        type(payload.amount_minor) ~= 'number'
        or payload.amount_minor % 1 ~= 0
        or payload.amount_minor < 1
        or payload.amount_minor > 100000000
    then
        return nil, 'amount_minor'
    end
    if
        type(payload.purpose) ~= 'string'
        or #payload.purpose < 1
        or #payload.purpose > 120
        or payload.purpose:match('^%s*$')
    then
        return nil, 'purpose'
    end
    if
        type(payload.request_id) ~= 'string'
        or payload.request_id == ''
        or #payload.request_id > 96
    then
        return nil, 'request_id'
    end
    if
        type(payload.operation_uuid) ~= 'string'
        or not payload.operation_uuid:match(uuid_pattern)
    then
        return nil, 'operation_uuid'
    end
    if payload.contract_version ~= Policy.contract_version then
        return nil, 'contract_version'
    end
    return {
        recipient_account_number = payload.recipient_account_number:upper(),
        amount_minor = payload.amount_minor,
        purpose = payload.purpose:match('^%s*(.-)%s*$'),
        request_id = payload.request_id,
        operation_uuid = payload.operation_uuid:lower(),
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
