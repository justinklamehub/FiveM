-- Evaluates technical permissions and protects role mutations with server-authoritative checks.
local PermissionIdentifier = require('shared.permission_identifier')
local PermissionRepository = require('server.repositories.permission_repository')

local PermissionService = {}

local function correlation_id(value)
    if type(value) == 'string' and value ~= '' then
        return value
    end
    return exports.cnr_core:create_correlation_id()
end

local function failure(code, message_key, safe_details, request_correlation_id)
    return exports.cnr_core:create_error_result(
        code,
        message_key,
        safe_details or {},
        correlation_id(request_correlation_id)
    )
end

local function success(data, request_correlation_id)
    return exports.cnr_core:create_success_result(data, correlation_id(request_correlation_id))
end

local function valid_uuid(value)
    return type(value) == 'string'
        and #value == 36
        and value:match(
                '^[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+$'
            )
            ~= nil
end

local function normalize_ends_at(value)
    if value == nil or value == '' then
        return nil
    end
    if type(value) ~= 'string' then
        return false
    end
    if not value:match('^%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d$') then
        return false
    end
    return value
end

local function require_account(account_uuid, request_correlation_id)
    if not valid_uuid(account_uuid) then
        return nil,
            failure(
                'VALIDATION_ERROR',
                'permissions.error.invalid_account_uuid',
                {},
                request_correlation_id
            )
    end

    local exists, database_error = PermissionRepository.account_exists(account_uuid)
    if database_error then
        return nil, database_error
    end
    if not exists then
        return nil,
            failure('NOT_FOUND', 'permissions.error.account_not_found', {}, request_correlation_id)
    end
    return true
end

local function require_manage_permission(actor_uuid, request_correlation_id)
    local actor_ready, actor_error = require_account(actor_uuid, request_correlation_id)
    if not actor_ready then
        return nil, actor_error
    end

    local allowed, database_error =
        PermissionRepository.has_permission(actor_uuid, 'permissions.manage')
    if database_error then
        return nil, database_error
    end
    if not allowed then
        return nil,
            failure(
                'PERMISSION_DENIED',
                'permissions.error.denied',
                { required_permission = 'permissions.manage' },
                request_correlation_id
            )
    end
    return true
end

---@param account_uuid string
---@param request_correlation_id? string
---@return table
function PermissionService.get_snapshot(account_uuid, request_correlation_id)
    local account_ready, account_error = require_account(account_uuid, request_correlation_id)
    if not account_ready then
        return account_error
    end

    local expire_result = PermissionRepository.expire_assignments(account_uuid)
    if not expire_result.ok then
        return expire_result
    end

    local snapshot, database_error = PermissionRepository.get_snapshot(account_uuid)
    if database_error then
        return database_error
    end

    local roles = {}
    for _, role in ipairs(snapshot.roles) do
        roles[#roles + 1] = {
            code = role.code,
            priority = tonumber(role.priority) or 0,
            starts_at = role.starts_at,
            ends_at = role.ends_at,
        }
    end

    local permissions = {}
    for _, permission in ipairs(snapshot.permissions) do
        permissions[#permissions + 1] = permission.code
    end

    return success({
        account_uuid = account_uuid,
        roles = roles,
        permissions = permissions,
    }, request_correlation_id)
end

---@param account_uuid string
---@param permission_code string
---@param request_correlation_id? string
---@return table
function PermissionService.has_permission(account_uuid, permission_code, request_correlation_id)
    local normalized_permission = PermissionIdentifier.permission(permission_code)
    if not normalized_permission then
        return failure(
            'VALIDATION_ERROR',
            'permissions.error.invalid_permission',
            {},
            request_correlation_id
        )
    end

    local account_ready, account_error = require_account(account_uuid, request_correlation_id)
    if not account_ready then
        return account_error
    end

    local expire_result = PermissionRepository.expire_assignments(account_uuid)
    if not expire_result.ok then
        return expire_result
    end

    local allowed, database_error =
        PermissionRepository.has_permission(account_uuid, normalized_permission)
    if database_error then
        return database_error
    end

    return success({
        account_uuid = account_uuid,
        permission = normalized_permission,
        allowed = allowed,
    }, request_correlation_id)
end

---@param account_uuid string
---@param permission_code string
---@param request_correlation_id? string
---@return table
function PermissionService.require_permission(account_uuid, permission_code, request_correlation_id)
    local result =
        PermissionService.has_permission(account_uuid, permission_code, request_correlation_id)
    if not result.ok or result.data.allowed then
        return result
    end

    return failure(
        'PERMISSION_DENIED',
        'permissions.error.denied',
        { required_permission = result.data.permission },
        result.correlation_id
    )
end

local function prepare_mutation(
    actor_uuid,
    account_uuid,
    role_code,
    reason_code,
    ends_at,
    request_correlation_id,
    bypass_authorization
)
    if not bypass_authorization then
        local authorized, authorization_error =
            require_manage_permission(actor_uuid, request_correlation_id)
        if not authorized then
            return nil, authorization_error
        end
    end

    local target_ready, target_error = require_account(account_uuid, request_correlation_id)
    if not target_ready then
        return nil, target_error
    end

    local normalized_role = PermissionIdentifier.role(role_code)
    local normalized_reason = PermissionIdentifier.reason(reason_code, 'manual_assignment')
    local normalized_ends_at = normalize_ends_at(ends_at)
    if not normalized_role or not normalized_reason or normalized_ends_at == false then
        return nil,
            failure(
                'VALIDATION_ERROR',
                'permissions.error.invalid_assignment',
                {},
                request_correlation_id
            )
    end

    if normalized_role == 'owner' and not bypass_authorization then
        return nil,
            failure(
                'PERMISSION_DENIED',
                'permissions.error.owner_console_only',
                {},
                request_correlation_id
            )
    end

    local role, role_error = PermissionRepository.find_role(normalized_role)
    if role_error then
        return nil, role_error
    end
    if not role then
        return nil,
            failure(
                'NOT_FOUND',
                'permissions.error.role_not_found',
                { role = normalized_role },
                request_correlation_id
            )
    end

    local expire_result = PermissionRepository.expire_assignments(account_uuid)
    if not expire_result.ok then
        return nil, expire_result
    end

    return {
        actor_uuid = bypass_authorization and nil or actor_uuid,
        account_uuid = account_uuid,
        role_code = normalized_role,
        reason_code = normalized_reason,
        ends_at = normalized_ends_at,
    }
end

---@param actor_uuid string
---@param account_uuid string
---@param role_code string
---@param reason_code? string
---@param ends_at? string
---@param request_correlation_id? string
---@return table
function PermissionService.grant_role(
    actor_uuid,
    account_uuid,
    role_code,
    reason_code,
    ends_at,
    request_correlation_id
)
    local assignment, preparation_error = prepare_mutation(
        actor_uuid,
        account_uuid,
        role_code,
        reason_code,
        ends_at,
        request_correlation_id,
        false
    )
    if not assignment then
        return preparation_error
    end

    local existing, database_error =
        PermissionRepository.find_active_assignment(account_uuid, assignment.role_code)
    if database_error then
        return database_error
    end
    if existing then
        return failure(
            'CONFLICT',
            'permissions.error.role_already_assigned',
            { role = assignment.role_code },
            request_correlation_id
        )
    end

    assignment.public_uuid = exports.cnr_core:create_uuid_v7()
    local grant_result = PermissionRepository.grant_role(assignment)
    if not grant_result.ok then
        return grant_result
    end

    exports.cnr_logs:audit('cnr_permissions', 'technical_role.granted', {
        actor_account_uuid = actor_uuid,
        target_account_uuid = account_uuid,
        role = assignment.role_code,
        reason_code = assignment.reason_code,
        ends_at = assignment.ends_at,
        correlation_id = correlation_id(request_correlation_id),
    })

    return success({
        assignment_uuid = assignment.public_uuid,
        account_uuid = account_uuid,
        role = assignment.role_code,
        ends_at = assignment.ends_at,
    }, request_correlation_id)
end

---@param actor_uuid string
---@param account_uuid string
---@param role_code string
---@param reason_code? string
---@param request_correlation_id? string
---@return table
function PermissionService.revoke_role(
    actor_uuid,
    account_uuid,
    role_code,
    reason_code,
    request_correlation_id
)
    local revocation, preparation_error = prepare_mutation(
        actor_uuid,
        account_uuid,
        role_code,
        reason_code or 'manual_revocation',
        nil,
        request_correlation_id,
        false
    )
    if not revocation then
        return preparation_error
    end

    local existing, database_error =
        PermissionRepository.find_active_assignment(account_uuid, revocation.role_code)
    if database_error then
        return database_error
    end
    if not existing then
        return failure(
            'NOT_FOUND',
            'permissions.error.assignment_not_found',
            { role = revocation.role_code },
            request_correlation_id
        )
    end

    local revoke_result = PermissionRepository.revoke_role(revocation)
    if not revoke_result.ok then
        return revoke_result
    end

    exports.cnr_logs:audit('cnr_permissions', 'technical_role.revoked', {
        actor_account_uuid = actor_uuid,
        target_account_uuid = account_uuid,
        role = revocation.role_code,
        reason_code = revocation.reason_code,
        correlation_id = correlation_id(request_correlation_id),
    })

    return success(
        { account_uuid = account_uuid, role = revocation.role_code },
        request_correlation_id
    )
end

---@param account_uuid string
---@param role_code string
---@param reason_code? string
---@param ends_at? string
---@param request_correlation_id? string
---@return table
function PermissionService.bootstrap_grant(
    account_uuid,
    role_code,
    reason_code,
    ends_at,
    request_correlation_id
)
    local assignment, preparation_error = prepare_mutation(
        nil,
        account_uuid,
        role_code,
        reason_code or 'server_console_bootstrap',
        ends_at,
        request_correlation_id,
        true
    )
    if not assignment then
        return preparation_error
    end

    local existing, database_error =
        PermissionRepository.find_active_assignment(account_uuid, assignment.role_code)
    if database_error then
        return database_error
    end
    if existing then
        return failure(
            'CONFLICT',
            'permissions.error.role_already_assigned',
            { role = assignment.role_code },
            request_correlation_id
        )
    end

    assignment.public_uuid = exports.cnr_core:create_uuid_v7()
    local grant_result = PermissionRepository.grant_role(assignment)
    if not grant_result.ok then
        return grant_result
    end

    exports.cnr_logs:audit('cnr_permissions', 'technical_role.bootstrap_granted', {
        target_account_uuid = account_uuid,
        role = assignment.role_code,
        reason_code = assignment.reason_code,
        ends_at = assignment.ends_at,
        correlation_id = correlation_id(request_correlation_id),
    })

    return success({
        assignment_uuid = assignment.public_uuid,
        account_uuid = account_uuid,
        role = assignment.role_code,
        ends_at = assignment.ends_at,
    }, request_correlation_id)
end

---@param account_uuid string
---@param role_code string
---@param reason_code? string
---@param request_correlation_id? string
---@return table
function PermissionService.bootstrap_revoke(
    account_uuid,
    role_code,
    reason_code,
    request_correlation_id
)
    local revocation, preparation_error = prepare_mutation(
        nil,
        account_uuid,
        role_code,
        reason_code or 'server_console_revocation',
        nil,
        request_correlation_id,
        true
    )
    if not revocation then
        return preparation_error
    end

    local existing, database_error =
        PermissionRepository.find_active_assignment(account_uuid, revocation.role_code)
    if database_error then
        return database_error
    end
    if not existing then
        return failure(
            'NOT_FOUND',
            'permissions.error.assignment_not_found',
            { role = revocation.role_code },
            request_correlation_id
        )
    end

    local revoke_result = PermissionRepository.revoke_role(revocation)
    if not revoke_result.ok then
        return revoke_result
    end

    exports.cnr_logs:audit('cnr_permissions', 'technical_role.bootstrap_revoked', {
        target_account_uuid = account_uuid,
        role = revocation.role_code,
        reason_code = revocation.reason_code,
        correlation_id = correlation_id(request_correlation_id),
    })

    return success(
        { account_uuid = account_uuid, role = revocation.role_code },
        request_correlation_id
    )
end

return PermissionService
