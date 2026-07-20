-- Declares server-authoritative financial accounts and immutable ledger reads.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Character accounts, immutable transfers, and proximity-secured dynamic ATMs.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_config',
    'cnr_core',
    'cnr_sessions',
    'cnr_characters',
    'cnr_permissions',
})

server_only('yes')
shared_script('shared/banking_policy.lua')
server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/banking_repository.lua',
    'server/services/banking_service.lua',
    'server/main.lua',
})
