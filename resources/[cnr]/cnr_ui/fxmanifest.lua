-- Declares the shared React NUI shell and its FiveM focus bridge.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('English Wave 1 loadscreen and server-driven player lifecycle NUI.')
version('0.1.0')

dependencies({
    '/onesync',
    'spawnmanager',
})

shared_script('shared/lifecycle_contract.lua')
client_script('client/main.lua')
server_script('server/main.lua')

ui_page('web/dist/index.html')
loadscreen('web/dist/loadscreen.html')
loadscreen_manual_shutdown('yes')

files({
    'web/dist/index.html',
    'web/dist/loadscreen.html',
    'web/dist/assets/**',
})
