-- Declares the server-side localization registry with German as the default language.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Server-side localization registry with German default.')
version('0.1.0')

dependencies({
    '/onesync',
})

server_only('yes')

server_scripts({
    'locales/de.lua',
    'locales/en.lua',
    'server/main.lua',
})
