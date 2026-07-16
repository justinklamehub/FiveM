-- Declares account ownership, normalized identifier handling, and registration state.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Server-authoritative account and platform identifier lifecycle.')
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

shared_script('shared/account_status.lua')

server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/account_repository.lua',
    'server/services/identifier_service.lua',
    'server/services/account_service.lua',
    'server/main.lua',
})
