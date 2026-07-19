-- Declares server-authoritative personal inventories and item transactions.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Personal inventories, idempotent starter items, and atomic transfers.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_config',
    'cnr_core',
    'cnr_sessions',
    'cnr_characters',
    'cnr_items',
})

server_only('yes')
shared_script('shared/inventory_policy.lua')
server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/inventory_repository.lua',
    'server/services/inventory_service.lua',
    'server/main.lua',
})
