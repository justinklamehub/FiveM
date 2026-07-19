-- Resolves or creates accounts from normalized identifiers while enforcing collision safety.
local AccountStatus = require('shared.account_status')
local IdentifierService = require('server.services.identifier_service')
local AccountRepository = require('server.repositories.account_repository')

local AccountService = {}

local function failure(code, message_key, safe_details, correlation_id)
    return exports.cnr_core:create_error_result(code, message_key, safe_details, correlation_id)
end

local function success(data, correlation_id)
    return exports.cnr_core:create_success_result(data, correlation_id)
end

local function get_pepper()
    local pepper = GetConvar('cnr_identifier_pepper', '')
    if #pepper < 32 or pepper:find('replace', 1, true) then
        return nil
    end
    return pepper
end

---@param raw_identifiers table
---@param correlation_id string
---@return table
function AccountService.resolve(raw_identifiers, correlation_id)
    local pepper = get_pepper()
    if not pepper then
        return failure(
            'DEPENDENCY_UNAVAILABLE',
            'accounts.error.identifier_pepper_missing',
            {},
            correlation_id
        )
    end

    local normalized, identifier_error = IdentifierService.normalize(raw_identifiers)
    if not normalized then
        return failure(identifier_error, 'accounts.error.identifier_required', {}, correlation_id)
    end

    for _, identifier in ipairs(normalized.identifiers) do
        identifier.is_primary = identifier.value == normalized.primary.value
    end

    local resolved_account = nil
    for _, identifier in ipairs(normalized.identifiers) do
        local account, database_error = AccountRepository.find_by_identifier(identifier, pepper)
        if database_error then
            return database_error
        end
        if account then
            if resolved_account and resolved_account.public_uuid ~= account.public_uuid then
                return failure(
                    'IDENTIFIER_CONFLICT',
                    'accounts.error.identifier_conflict',
                    {},
                    correlation_id
                )
            end
            resolved_account = account
        end
    end

    local created = false
    if not resolved_account then
        if GetConvarInt('cnr_registration_enabled', 1) ~= 1 then
            return failure(
                'REGISTRATION_DISABLED',
                'accounts.error.registration_disabled',
                {},
                correlation_id
            )
        end

        local public_uuid = exports.cnr_core:create_uuid_v7()
        local create_result = AccountRepository.create(public_uuid, normalized.identifiers, pepper)
        if not create_result.ok then
            for _, identifier in ipairs(normalized.identifiers) do
                local retry_account = AccountRepository.find_by_identifier(identifier, pepper)
                if retry_account then
                    resolved_account = retry_account
                    break
                end
            end
            if not resolved_account then
                return create_result
            end
        else
            resolved_account = AccountRepository.find_by_public_uuid(public_uuid)
            created = true
            exports.cnr_logs:audit('cnr_accounts', 'account.created', {
                account_uuid = public_uuid,
                identifier_types = (function()
                    local values = {}
                    for _, identifier in ipairs(normalized.identifiers) do
                        values[#values + 1] = identifier.type
                    end
                    return values
                end)(),
                correlation_id = correlation_id,
            })
        end
    end

    for _, identifier in ipairs(normalized.identifiers) do
        local account = AccountRepository.find_by_identifier(identifier, pepper)
        if account and account.public_uuid ~= resolved_account.public_uuid then
            return failure(
                'IDENTIFIER_CONFLICT',
                'accounts.error.identifier_conflict',
                {},
                correlation_id
            )
        end
    end

    local touch_result = AccountRepository.touch_identifiers(
        resolved_account.public_uuid,
        normalized.identifiers,
        pepper
    )
    if not touch_result.ok then
        return touch_result
    end

    local restriction, restriction_error =
        AccountRepository.find_active_restriction(resolved_account.public_uuid)
    if restriction_error then
        return restriction_error
    end

    if AccountStatus.is_connection_blocked(resolved_account.status) or restriction then
        local code = resolved_account.status == AccountStatus.BANNED and 'ACCOUNT_BANNED'
            or 'ACCOUNT_RESTRICTED'
        return failure(code, 'accounts.error.connection_restricted', {}, correlation_id)
    end

    local hints = {}
    for _, identifier in ipairs(normalized.identifiers) do
        hints[#hints + 1] = { type = identifier.type, hint = identifier.hint }
    end

    return success({
        account = {
            public_uuid = resolved_account.public_uuid,
            status = resolved_account.status,
            version = resolved_account.version,
        },
        identifier_hints = hints,
        created = created,
    }, correlation_id)
end

return AccountService
