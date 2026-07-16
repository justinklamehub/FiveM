-- Declares the small standalone core that coordinates technical readiness and request contracts.
fx_version('cerulean')
game('gta5')

author("Cops'N'Robbers RP")
description('Small standalone core for readiness, results, errors, and correlation IDs.')
version('0.1.0')

dependencies({
    '/onesync',
    'cnr_database',
    'cnr_logs',
    'cnr_locales',
    'cnr_config',
})

server_only('yes')

shared_scripts({
    'shared/error_codes.lua',
    'shared/correlation.lua',
    'shared/uuid_v7.lua',
    'shared/result.lua',
    'shared/readiness.lua',
    'shared/rate_limiter.lua',
    'shared/request_context.lua',
})

server_script('server/main.lua')
