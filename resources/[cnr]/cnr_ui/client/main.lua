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
RegisterNUICallback('uiReady', function(_, callback)
    TriggerServerEvent('cnr:ui:ready')
    callback({ ok = true })
end)
local pending_registration = {}
local request_timeout_ms = 15000
local function expire_pending(pending, request_id)
    local expected = pending[request_id]
    SetTimeout(request_timeout_ms, function()
        if pending[request_id] == expected then
            pending[request_id] = nil
        end
    end)
end
local registration_events = {
    status = 'registrationStatus',
    ruleset = 'registrationRuleset',
    submit = 'registrationSubmit',
}
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
    pending_registration[request_id] = {
        action = action,
        event = registration_events[action],
    }
    expire_pending(pending_registration, request_id)
    TriggerServerEvent('cnr:registration:request', action, payload)
    callback({ ok = true, queued = true, request_id = request_id })
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
RegisterNetEvent('cnr:registration:response', function(action, request_id, result)
    local pending = pending_registration[request_id]
    if pending and pending.action == action then
        pending_registration[request_id] = nil
        SendNUIMessage({
            version = 1,
            type = 'ui.request.response',
            payload = {
                event = pending.event,
                request_id = request_id,
                result = result,
            },
        })
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
    pending_characters[request_id] = {
        action = action,
        event = 'characters.' .. action,
    }
    expire_pending(pending_characters, request_id)
    TriggerServerEvent('cnr:characters:request', action, payload)
    callback({ ok = true, queued = true, request_id = request_id })
end
for _, callback_name in ipairs({ 'configuration', 'list', 'createDraft', 'activate' }) do
    RegisterNUICallback('characters.' .. callback_name, function(payload, callback)
        character_request(callback_name, payload, callback)
    end)
end
RegisterNetEvent('cnr:characters:response', function(action, request_id, result)
    local pending = pending_characters[request_id]
    if pending and pending.action == action then
        pending_characters[request_id] = nil
        SendNUIMessage({
            version = 1,
            type = 'ui.request.response',
            payload = {
                event = pending.event,
                request_id = request_id,
                result = result,
            },
        })
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
        payload = { view = view, locale = locale or 'en' },
    })
end)
RegisterCommand('cnr_registration_open', function()
    TriggerEvent('cnr:ui:open', 'registration', 'en')
end, false)
AddEventHandler('onClientResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        set_focus(nil)
    end
end)
