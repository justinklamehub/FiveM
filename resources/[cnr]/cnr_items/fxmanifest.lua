-- Declares the server-authoritative Wave 2 item catalogue.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Versioned server-owned item definitions and catalogue reads.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_config',
    'cnr_core',
})

server_only('yes')
shared_script('shared/item_policy.lua')
server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/item_repository.lua',
    'server/services/item_service.lua',
    'server/main.lua',
})
