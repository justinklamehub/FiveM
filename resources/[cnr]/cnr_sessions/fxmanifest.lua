-- Declares the connection deferral and active account session coordinator.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Connection, deferral, and one-active-session lifecycle.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_locales',
    'cnr_config',
    'cnr_core',
    'cnr_accounts',
    'cnr_whitelist',
})

server_only('yes')

shared_script('shared/access_policy.lua')

server_scripts({
    'server/repositories/session_repository.lua',
    'server/services/session_service.lua',
    'server/main.lua',
})
