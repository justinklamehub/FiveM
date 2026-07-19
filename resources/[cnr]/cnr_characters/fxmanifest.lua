-- Declares server-authoritative character identity, selection, appearance, and spawn state.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Atomic character lifecycle, persistent appearance, and controlled spawn authority.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_config',
    'cnr_core',
    'cnr_accounts',
    'cnr_sessions',
})

server_only('yes')
shared_script('shared/character_policy.lua')
server_scripts({
    '@cnr_core/shared/module_path.lua',
    'server/repositories/character_repository.lua',
    'server/services/character_service.lua',
    'server/main.lua',
})
