-- Owns FiveM NUI focus and forwards versioned shell messages to the browser.
local focus_owner = nil
local function set_focus(owner)
    focus_owner = owner
    SetNuiFocus(owner ~= nil, owner ~= nil)
    SetNuiFocusKeepInput(false)
end
RegisterNUICallback('close', function(_, callback)
    set_focus(nil)
    callback({ ok = true })
end)
local pending_registration = {}
local function registration_request(action, payload, callback)
    local request_id = payload and payload.request_id
    if type(request_id) ~= 'string' or request_id == '' or pending_registration[request_id] then
        callback({
            ok = false,
            error = {
                code = 'VALIDATION_ERROR',
                message_key = 'registration.error.invalid_request',
            },
        })
        return
    end
    pending_registration[request_id] = callback
    TriggerServerEvent('cnr:registration:request', action, payload)
end
RegisterNUICallback('registrationStatus', function(payload, callback)
    registration_request('status', payload, callback)
end)
RegisterNUICallback('registrationRuleset', function(payload, callback)
    registration_request('ruleset', payload, callback)
end)
RegisterNUICallback('registrationSubmit', function(payload, callback)
    registration_request('submit', payload, callback)
end)
RegisterNetEvent('cnr:registration:response', function(_, request_id, result)
    local callback = pending_registration[request_id]
    if callback then
        pending_registration[request_id] = nil
        callback(result)
    end
end)
local pending_characters = {}
local function character_request(action, payload, callback)
    local request_id = payload and payload.request_id
    if type(request_id) ~= 'string' or request_id == '' or pending_characters[request_id] then
        callback({
            ok = false,
            error = {
                code = 'VALIDATION_ERROR',
                message_key = 'characters.error.invalid_request',
            },
        })
        return
    end
    pending_characters[request_id] = callback
    TriggerServerEvent('cnr:characters:request', action, payload)
end
for _, callback_name in ipairs({ 'configuration', 'list', 'createDraft', 'activate' }) do
    RegisterNUICallback('characters.' .. callback_name, function(payload, callback)
        character_request(callback_name, payload, callback)
    end)
end
RegisterNetEvent('cnr:characters:response', function(_, request_id, result)
    local callback = pending_characters[request_id]
    if callback then
        pending_characters[request_id] = nil
        callback(result)
    end
end)
RegisterNetEvent('cnr:ui:open', function(view, locale)
    if focus_owner and focus_owner ~= view then
        return
    end
    set_focus(view)
    SendNUIMessage({
        version = 1,
        type = 'ui.shell.open',
        payload = { view = view, locale = locale or 'de' },
    })
end)
AddEventHandler('onClientResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        set_focus(nil)
    end
end)
