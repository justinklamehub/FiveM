-- Verifies technical role, permission, and audit reason identifier contracts.
local PermissionIdentifier =
    dofile('resources/[cnr]/cnr_permissions/shared/permission_identifier.lua')

describe('technical permission identifiers', function()
    it('normalizes valid permission codes', function()
        assert.are.equal(
            'permissions.manage',
            PermissionIdentifier.permission('  PERMISSIONS.MANAGE  ')
        )
        assert.are.equal(
            'sessions.terminate',
            PermissionIdentifier.permission('sessions.terminate')
        )
    end)

    it('rejects malformed permission codes', function()
        assert.is_nil(PermissionIdentifier.permission('permissions'))
        assert.is_nil(PermissionIdentifier.permission('.permissions.manage'))
        assert.is_nil(PermissionIdentifier.permission('permissions..manage'))
        assert.is_nil(PermissionIdentifier.permission('../permissions.manage'))
    end)

    it('normalizes role and reason codes independently', function()
        assert.are.equal('administrator', PermissionIdentifier.role('Administrator'))
        assert.are.equal(
            'server_console.bootstrap',
            PermissionIdentifier.reason('Server_Console.Bootstrap')
        )
    end)

    it('rejects roleplay-style or unsafe role identifiers', function()
        assert.is_nil(PermissionIdentifier.role('police.chief'))
        assert.is_nil(PermissionIdentifier.role('../owner'))
        assert.is_nil(PermissionIdentifier.reason('reason with spaces'))
    end)
end)
