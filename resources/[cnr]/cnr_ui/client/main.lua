-- Owns FiveM NUI focus and forwards versioned shell messages to the browser.
local focus_owner = nil
local lifecycle_locked = false
local preview_camera = nil
local active_spawn_uuid = nil
local function set_focus(owner)
    focus_owner = owner
    SetNuiFocus(owner ~= nil, owner ~= nil)
    SetNuiFocusKeepInput(false)
end
RegisterNUICallback('close', function(_, callback)
    if lifecycle_locked then
        callback({ ok = false, locked = true })
        return
    end
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
for _, callback_name in ipairs({
    'configuration',
    'list',
    'createDraft',
    'activate',
    'selectionStatus',
    'select',
    'appearanceConfiguration',
    'appearanceSave',
}) do
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

local function hold_player(hidden)
    local ped = PlayerPedId()
    if ped == 0 then
        return
    end
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetEntityCollision(ped, false, false)
    SetEntityVisible(ped, not hidden, false)
end

local function release_player()
    local ped = PlayerPedId()
    if ped == 0 then
        return
    end
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, true, false)
end

local function destroy_preview_camera()
    if preview_camera then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(preview_camera, false)
        preview_camera = nil
    end
end

local function load_model(model)
    if type(model) ~= 'string' and type(model) ~= 'number' then
        return nil
    end
    local hash = type(model) == 'number' and model or GetHashKey(model)
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        return nil
    end
    RequestModel(hash)
    local deadline = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < deadline do
        Wait(0)
    end
    if not HasModelLoaded(hash) then
        return nil
    end
    return hash
end

local function apply_appearance(appearance)
    if type(appearance) ~= 'table' then
        return false
    end
    local hash = load_model(appearance.model)
    if not hash then
        return false
    end
    if GetEntityModel(PlayerPedId()) ~= hash then
        SetPlayerModel(PlayerId(), hash)
    end
    SetModelAsNoLongerNeeded(hash)
    local ped = PlayerPedId()
    SetPedDefaultComponentVariation(ped)
    if appearance.outfit_code == 'starter_casual' then
        local feminine = appearance.model == 'mp_f_freemode_01'
        SetPedComponentVariation(ped, 3, feminine and 14 or 0, 0, 2)
        SetPedComponentVariation(ped, 4, 0, 0, 2)
        SetPedComponentVariation(ped, 6, 1, 0, 2)
        SetPedComponentVariation(ped, 8, feminine and 14 or 15, 0, 2)
        SetPedComponentVariation(ped, 11, 15, 0, 2)
    end
    SetPedHeadBlendData(
        ped,
        appearance.shape_first,
        appearance.shape_second,
        0,
        appearance.shape_first,
        appearance.shape_second,
        0,
        appearance.shape_mix / 100.0,
        appearance.skin_mix / 100.0,
        0.0,
        false
    )
    for index = 1, 20 do
        SetPedFaceFeature(ped, index - 1, (appearance.face_features[index] or 0) / 100.0)
    end
    SetPedComponentVariation(ped, 2, appearance.hair_style, appearance.hair_texture, 2)
    SetPedHairTint(ped, appearance.hair_color, appearance.hair_highlight)
    SetPedEyeColor(ped, appearance.eye_color)
    return true
end

RegisterNUICallback('characters.appearanceBegin', function(_, callback)
    callback({ ok = true })
    CreateThread(function()
        local ped = PlayerPedId()
        SetEntityCoordsNoOffset(ped, 402.92, -996.72, -99.0, false, false, false)
        SetEntityHeading(ped, 180.0)
        hold_player(false)
        destroy_preview_camera()
        preview_camera = CreateCamWithParams(
            'DEFAULT_SCRIPTED_CAMERA',
            402.92,
            -999.15,
            -98.35,
            0.0,
            0.0,
            0.0,
            42.0,
            true,
            2
        )
        PointCamAtEntity(preview_camera, ped, 0.0, 0.0, 0.65, true)
        RenderScriptCams(true, true, 500, true, true)
    end)
end)

RegisterNUICallback('characters.appearancePreview', function(payload, callback)
    callback({ ok = true })
    CreateThread(function()
        apply_appearance(payload)
        hold_player(false)
        if preview_camera then
            PointCamAtEntity(preview_camera, PlayerPedId(), 0.0, 0.0, 0.65, true)
        end
    end)
end)

RegisterNetEvent('cnr:characters:lifecycleReady', function()
    lifecycle_locked = false
    destroy_preview_camera()
    release_player()
    set_focus(nil)
    SendNUIMessage({ version = 1, type = 'ui.shell.close', payload = {} })
end)

RegisterNetEvent('cnr:characters:spawn', function(instruction)
    if
        type(instruction) ~= 'table'
        or type(instruction.spawn_uuid) ~= 'string'
        or active_spawn_uuid == instruction.spawn_uuid
    then
        return
    end
    active_spawn_uuid = instruction.spawn_uuid
    lifecycle_locked = true
    hold_player(true)
    destroy_preview_camera()
    local model = load_model(instruction.appearance and instruction.appearance.model)
    if not model then
        TriggerServerEvent('cnr:characters:spawnAck', { spawn_uuid = 'invalid-model' })
        return
    end
    exports.spawnmanager:spawnPlayer({
        x = instruction.x,
        y = instruction.y,
        z = instruction.z,
        heading = instruction.heading,
        model = model,
        skipFade = false,
    }, function()
        apply_appearance(instruction.appearance)
        hold_player(true)
        TriggerServerEvent('cnr:characters:spawnAck', { spawn_uuid = instruction.spawn_uuid })
    end)
end)

RegisterNetEvent('cnr:characters:spawnConfirmed', function(spawn_uuid)
    if spawn_uuid ~= active_spawn_uuid then
        return
    end
    active_spawn_uuid = nil
    lifecycle_locked = false
    destroy_preview_camera()
    release_player()
    set_focus(nil)
    SendNUIMessage({ version = 1, type = 'ui.shell.close', payload = {} })
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)

RegisterNetEvent('cnr:characters:spawnRejected', function(correlation_id)
    active_spawn_uuid = nil
    hold_player(true)
    SendNUIMessage({
        version = 1,
        type = 'ui.character.spawn_failed',
        payload = { correlation_id = correlation_id },
    })
end)
RegisterNetEvent('cnr:ui:open', function(view, locale)
    if focus_owner and focus_owner ~= view then
        return
    end
    set_focus(view)
    if view == 'registration' or view == 'characterLifecycle' then
        lifecycle_locked = true
        hold_player(true)
    end
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
        destroy_preview_camera()
        release_player()
    end
end)

CreateThread(function()
    pcall(function()
        exports.spawnmanager:setAutoSpawn(false)
    end)
end)
