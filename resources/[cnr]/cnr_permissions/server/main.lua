-- Exposes technical permission checks and console-only bootstrap role management.
local PermissionRepository = require('server.repositories.permission_repository')
local PermissionService = require('server.services.permission_service')
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local status = {
    resource = resource_name,
    version = version,
    status = 'starting',
    changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    details = {},
}

local function publish(next_status, details)
    status.status = next_status
    status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
    status.details = details or {}
    exports.cnr_core:report_resource_status(status)
end

local function unavailable(correlation_id)
    return exports.cnr_core:create_error_result(
        'DEPENDENCY_UNAVAILABLE',
        'permissions.error.unavailable',
        { status = status.status },
        correlation_id or exports.cnr_core:create_correlation_id()
    )
end

local function console_only(source)
    if source == 0 then
        return true
    end
    print(('[cnr_permissions] Rejected in-game use from source %s.'):format(source))
    return false
end

local function print_result(action, result)
    if result.ok then
        print(('[cnr_permissions] %s succeeded. Correlation: %s'):format(action, result.correlation_id))
        return
    end
    print(
        ('[cnr_permissions] %s failed: %s (%s)'):format(
            action,
            result.error.code,
            result.error.correlation_id
        )
    )
end

CreateThread(function()
    Wait(0)
    if not exports.cnr_core:is_ready() then
        publish('degraded', { reason = 'core_not_ready' })
        return
    end

    local counts, database_error = PermissionRepository.get_catalog_counts()
    if database_error then
        publish('unavailable', { reason = 'catalog_query_failed' })
        return
    end

    local role_count = counts and tonumber(counts.role_count) or 0
    local permission_count = counts and tonumber(counts.permission_count) or 0
    if role_count == 0 or permission_count == 0 then
        publish('unavailable', {
            reason = 'catalog_empty',
            role_count = role_count,
            permission_count = permission_count,
        })
        return
    end

    publish('ready', { role_count = role_count, permission_count = permission_count })
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
    end
end)

exports('get_status', function()
    return status
end)

exports('get_snapshot', function(account_uuid, correlation_id)
    if status.status ~= 'ready' then
        return unavailable(correlation_id)
    end
    return PermissionService.get_snapshot(account_uuid, correlation_id)
end)

exports('has_permission', function(account_uuid, permission_code, correlation_id)
    if status.status ~= 'ready' then
        return unavailable(correlation_id)
    end
    return PermissionService.has_permission(account_uuid, permission_code, correlation_id)
end)

exports('require_permission', function(account_uuid, permission_code, correlation_id)
    if status.status ~= 'ready' then
        return unavailable(correlation_id)
    end
    return PermissionService.require_permission(account_uuid, permission_code, correlation_id)
end)

exports('grant_role', function(
    actor_uuid,
    account_uuid,
    role_code,
    reason_code,
    ends_at,
    correlation_id
)
    if status.status ~= 'ready' then
        return unavailable(correlation_id)
    end
    return PermissionService.grant_role(
        actor_uuid,
        account_uuid,
        role_code,
        reason_code,
        ends_at,
        correlation_id
    )
end)

exports('revoke_role', function(
    actor_uuid,
    account_uuid,
    role_code,
    reason_code,
    correlation_id
)
    if status.status ~= 'ready' then
        return unavailable(correlation_id)
    end
    return PermissionService.revoke_role(
        actor_uuid,
        account_uuid,
        role_code,
        reason_code,
        correlation_id
    )
end)

RegisterCommand('cnr_role_grant', function(source, arguments)
    if not console_only(source) then
        return
    end
    if status.status ~= 'ready' then
        print_result('role grant', unavailable())
        return
    end

    local account_uuid = arguments[1]
    local role_code = arguments[2]
    local reason_code = arguments[3] or 'server_console_bootstrap'
    if not account_uuid or not role_code then
        print('[cnr_permissions] Usage: cnr_role_grant <account_uuid> <role_code> [reason_code]')
        return
    end

    print_result(
        'role grant',
        PermissionService.bootstrap_grant(account_uuid, role_code, reason_code)
    )
end, false)

RegisterCommand('cnr_role_revoke', function(source, arguments)
    if not console_only(source) then
        return
    end
    if status.status ~= 'ready' then
        print_result('role revoke', unavailable())
        return
    end

    local account_uuid = arguments[1]
    local role_code = arguments[2]
    local reason_code = arguments[3] or 'server_console_revocation'
    if not account_uuid or not role_code then
        print('[cnr_permissions] Usage: cnr_role_revoke <account_uuid> <role_code> [reason_code]')
        return
    end

    print_result(
        'role revoke',
        PermissionService.bootstrap_revoke(account_uuid, role_code, reason_code)
    )
end, false)

RegisterCommand('cnr_role_show', function(source, arguments)
    if not console_only(source) then
        return
    end
    if status.status ~= 'ready' then
        print_result('role show', unavailable())
        return
    end

    local account_uuid = arguments[1]
    if not account_uuid then
        print('[cnr_permissions] Usage: cnr_role_show <account_uuid>')
        return
    end

    local result = PermissionService.get_snapshot(account_uuid)
    if not result.ok then
        print_result('role show', result)
        return
    end

    local role_codes = {}
    for _, role in ipairs(result.data.roles) do
        role_codes[#role_codes + 1] = role.code
    end
    print(('[cnr_permissions] Account: %s'):format(account_uuid))
    print(('[cnr_permissions] Roles: %s'):format(table.concat(role_codes, ', ')))
    print(('[cnr_permissions] Permissions: %s'):format(table.concat(result.data.permissions, ', ')))
end, false)
