-- Declares the static Wave 0 configuration resource and its explicit dependencies.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Static technical configuration facade for Wave 0.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_logs',
    'cnr_locales',
})

server_only('yes')

server_scripts({
    'config/defaults.lua',
    'server/main.lua',
})
