-- Declares server-authoritative whitelist evaluation for account connections.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Whitelist mode and account entry evaluation.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_locales',
    'cnr_config',
    'cnr_core',
})

server_only('yes')

shared_script('shared/policy.lua')

server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/whitelist_repository.lua',
    'server/services/whitelist_service.lua',
    'server/main.lua',
})
