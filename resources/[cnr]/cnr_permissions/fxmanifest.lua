-- Declares database-driven technical roles and permissions for account-level administration.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Server-authoritative technical roles and permission evaluation.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_locales',
    'cnr_config',
    'cnr_core',
    'cnr_accounts',
})

server_only('yes')

shared_script('shared/permission_identifier.lua')

server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/permission_repository.lua',
    'server/services/permission_service.lua',
    'server/main.lua',
})
