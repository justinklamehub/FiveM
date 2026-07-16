-- Declares the structured application and audit logging resource.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Structured application and audit logging.')
version('0.1.0')

dependencies({
    '/onesync',
})

server_only('yes')

server_script('server/main.lua')
