-- Owns FiveM NUI focus and forwards versioned shell messages to the browser.
local focus_owner = nil
local lifecycle_locked = true
local lifecycle_phase = 'AWAITING_AUTHORITY'
local preview_camera = nil
local preview_ped = nil
local preview_appearance = nil
local preview_focus_active = false
local active_spawn_uuid = nil
local preview_scene = {
    ped_x = 402.92,
    ped_y = -996.72,
    ped_z = -99.0,
    ped_heading = 180.0,
    camera_x = 402.92,
    camera_y = -999.55,
    camera_z = -98.2,
    target_x = 403.55,
    target_y = -996.72,
    target_z = -98.35,
}
local starter_outfits = {
    ['mp_m_freemode_01'] = {
        -- Compatible base-game T-shirt, jeans, and sneakers.
        { component_id = 3, drawable_id = 15, texture_id = 0 },
        { component_id = 4, drawable_id = 0, texture_id = 0 },
        { component_id = 6, drawable_id = 1, texture_id = 0 },
        { component_id = 8, drawable_id = 15, texture_id = 0 },
        { component_id = 11, drawable_id = 15, texture_id = 0 },
    },
    ['mp_f_freemode_01'] = {
        -- Compatible base-game T-shirt, jeans, and sneakers.
        { component_id = 3, drawable_id = 15, texture_id = 0 },
        { component_id = 4, drawable_id = 0, texture_id = 0 },
        { component_id = 6, drawable_id = 1, texture_id = 0 },
        { component_id = 8, drawable_id = 14, texture_id = 0 },
        { component_id = 11, drawable_id = 15, texture_id = 0 },
    },
}
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
    SetPlayerInvincible(PlayerId(), true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetEntityCollision(ped, false, false)
    SetEntityVisible(ped, not hidden, false)
    SetEntityAlpha(ped, hidden and 0 or 255, false)
end

local function release_player()
    local ped = PlayerPedId()
    if ped == 0 then
        return
    end
    SetPlayerInvincible(PlayerId(), false)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, true, false)
    ResetEntityAlpha(ped)
end

local function destroy_preview_scene()
    if preview_camera then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(preview_camera, false)
        preview_camera = nil
    end
    if preview_ped and DoesEntityExist(preview_ped) then
        DeleteEntity(preview_ped)
    end
    preview_ped = nil
    preview_appearance = nil
    if preview_focus_active then
        ClearFocus()
        preview_focus_active = false
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

local function apply_component(ped, component)
    local drawable_count = GetNumberOfPedDrawableVariations(ped, component.component_id)
    if component.drawable_id < 0 or component.drawable_id >= drawable_count then
        return false
    end
    local texture_count =
        GetNumberOfPedTextureVariations(ped, component.component_id, component.drawable_id)
    local texture_id = math.min(component.texture_id, math.max(texture_count - 1, 0))
    SetPedComponentVariation(ped, component.component_id, component.drawable_id, texture_id, 2)
    return true
end

local function apply_starter_outfit(ped, model)
    local outfit = starter_outfits[model]
    if not outfit then
        return false
    end
    ClearAllPedProps(ped)
    for _, component in ipairs(outfit) do
        if not apply_component(ped, component) then
            return false
        end
    end
    return true
end

local function apply_ped_appearance(ped, appearance)
    if not ped or not DoesEntityExist(ped) or type(appearance) ~= 'table' then
        return false
    end
    SetPedDefaultComponentVariation(ped)
    if appearance.outfit_code == 'starter_casual' then
        apply_starter_outfit(ped, appearance.model)
    end
    SetPedHeadBlendData(
        ped,
        tonumber(appearance.shape_first) or 0,
        tonumber(appearance.shape_second) or 0,
        0,
        tonumber(appearance.shape_first) or 0,
        tonumber(appearance.shape_second) or 0,
        0,
        (tonumber(appearance.shape_mix) or 0) / 100.0,
        (tonumber(appearance.skin_mix) or 0) / 100.0,
        0.0,
        false
    )
    local face_features = type(appearance.face_features) == 'table' and appearance.face_features
        or {}
    for index = 1, 20 do
        SetPedFaceFeature(ped, index - 1, (tonumber(face_features[index]) or 0) / 100.0)
    end
    SetPedComponentVariation(
        ped,
        2,
        tonumber(appearance.hair_style) or 0,
        tonumber(appearance.hair_texture) or 0,
        2
    )
    SetPedHairTint(
        ped,
        tonumber(appearance.hair_color) or 0,
        tonumber(appearance.hair_highlight) or 0
    )
    SetPedEyeColor(ped, tonumber(appearance.eye_color) or 0)
    return true
end

local function apply_player_appearance(appearance)
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
    return apply_ped_appearance(PlayerPedId(), appearance)
end

local function ensure_preview_ped(appearance)
    if type(appearance) ~= 'table' then
        return false
    end
    local hash = load_model(appearance.model)
    if not hash then
        return false
    end
    if
        not preview_ped
        or not DoesEntityExist(preview_ped)
        or GetEntityModel(preview_ped) ~= hash
    then
        if preview_ped and DoesEntityExist(preview_ped) then
            DeleteEntity(preview_ped)
        end
        preview_ped = CreatePed(
            4,
            hash,
            preview_scene.ped_x,
            preview_scene.ped_y,
            preview_scene.ped_z,
            preview_scene.ped_heading,
            false,
            true
        )
    end
    SetModelAsNoLongerNeeded(hash)
    if not preview_ped or not DoesEntityExist(preview_ped) then
        return false
    end
    SetEntityCoordsNoOffset(
        preview_ped,
        preview_scene.ped_x,
        preview_scene.ped_y,
        preview_scene.ped_z,
        false,
        false,
        false
    )
    SetEntityHeading(preview_ped, preview_scene.ped_heading)
    FreezeEntityPosition(preview_ped, true)
    SetEntityInvincible(preview_ped, true)
    SetEntityCollision(preview_ped, false, false)
    SetEntityVisible(preview_ped, true, false)
    ResetEntityAlpha(preview_ped)
    SetBlockingOfNonTemporaryEvents(preview_ped, true)
    SetPedCanRagdoll(preview_ped, false)
    preview_appearance = appearance
    return apply_ped_appearance(preview_ped, appearance)
end

local function activate_preview_camera()
    if preview_camera then
        DestroyCam(preview_camera, false)
    end
    preview_camera = CreateCamWithParams(
        'DEFAULT_SCRIPTED_CAMERA',
        preview_scene.camera_x,
        preview_scene.camera_y,
        preview_scene.camera_z,
        0.0,
        0.0,
        0.0,
        38.0,
        true,
        2
    )
    PointCamAtCoord(
        preview_camera,
        preview_scene.target_x,
        preview_scene.target_y,
        preview_scene.target_z
    )
    SetCamActive(preview_camera, true)
    RenderScriptCams(true, true, 500, true, true)
end

RegisterNUICallback('characters.appearanceBegin', function(payload, callback)
    callback({ ok = true })
    CreateThread(function()
        lifecycle_locked = true
        lifecycle_phase = 'APPEARANCE_PREVIEW'
        hold_player(true)
        destroy_preview_scene()
        SetFocusPosAndVel(
            preview_scene.ped_x,
            preview_scene.ped_y,
            preview_scene.ped_z,
            0.0,
            0.0,
            0.0
        )
        preview_focus_active = true
        RequestCollisionAtCoord(preview_scene.ped_x, preview_scene.ped_y, preview_scene.ped_z)
        ensure_preview_ped(payload)
        activate_preview_camera()
    end)
end)

RegisterNUICallback('characters.appearancePreview', function(payload, callback)
    callback({ ok = true })
    CreateThread(function()
        lifecycle_locked = true
        lifecycle_phase = 'APPEARANCE_PREVIEW'
        hold_player(true)
        ensure_preview_ped(payload)
    end)
end)

RegisterNetEvent('cnr:characters:lifecycleReady', function()
    lifecycle_locked = false
    lifecycle_phase = 'RELEASED'
    destroy_preview_scene()
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
    lifecycle_phase = 'CONTROLLED_SPAWN'
    hold_player(true)
    destroy_preview_scene()
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
        apply_player_appearance(instruction.appearance)
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
    lifecycle_phase = 'RELEASED'
    destroy_preview_scene()
    release_player()
    set_focus(nil)
    SendNUIMessage({ version = 1, type = 'ui.shell.close', payload = {} })
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)

RegisterNetEvent('cnr:characters:spawnRejected', function(correlation_id)
    active_spawn_uuid = nil
    lifecycle_phase = 'SPAWN_REJECTED'
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
        lifecycle_phase = view == 'registration' and 'REGISTRATION' or 'CHARACTER_SELECTION'
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
        destroy_preview_scene()
        release_player()
    end
end)

CreateThread(function()
    while true do
        if lifecycle_locked then
            pcall(function()
                exports.spawnmanager:setAutoSpawn(false)
            end)
            Wait(250)
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if lifecycle_locked then
            DisableAllControlActions(0)
            DisablePlayerFiring(PlayerId(), true)
            HideHudAndRadarThisFrame()
            hold_player(true)
            if lifecycle_phase == 'APPEARANCE_PREVIEW' then
                if preview_ped and DoesEntityExist(preview_ped) then
                    FreezeEntityPosition(preview_ped, true)
                    SetEntityVisible(preview_ped, true, false)
                elseif preview_appearance then
                    ensure_preview_ped(preview_appearance)
                end
                if preview_camera then
                    SetCamActive(preview_camera, true)
                    RenderScriptCams(true, false, 0, true, true)
                end
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

AddEventHandler('playerSpawned', function()
    if not lifecycle_locked then
        return
    end
    CreateThread(function()
        Wait(0)
        hold_player(true)
        if lifecycle_phase == 'APPEARANCE_PREVIEW' and preview_appearance then
            ensure_preview_ped(preview_appearance)
            if not preview_camera then
                activate_preview_camera()
            end
        end
    end)
end)
