-- Declares the shared React NUI shell and its FiveM focus bridge.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Shared React NUI shell, focus bridge, and localization foundation.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_core',
    'cnr_logs',
    'cnr_locales',
    'cnr_config',
})

client_script('client/main.lua')
server_script('server/main.lua')

ui_page('web/dist/index.html')

files({
    'web/dist/index.html',
    'web/dist/assets/**',
})
