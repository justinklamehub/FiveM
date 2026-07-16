-- Declares server-authoritative registration, ruleset acceptance, and account activation.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Versioned, idempotent account registration and ruleset acceptance.')
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
    'cnr_sessions',
})

server_only('yes')

shared_script('shared/registration_policy.lua')
server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/registration_repository.lua',
    'server/services/registration_service.lua',
    'server/main.lua',
})
