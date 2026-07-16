-- Declares the database facade and pins oxmysql as its only vendor runtime dependency.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Encapsulated MariaDB access and schema readiness.')
version('0.1.0')

dependencies({
    '/onesync',
    'oxmysql',
})

server_only('yes')

server_scripts({
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
})
