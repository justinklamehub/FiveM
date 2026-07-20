-- Owns FiveM NUI focus and forwards versioned shell messages to the browser.
local focus_owner = nil
local document_previous_focus = nil
local lifecycle_locked = true
local lifecycle_phase = 'AWAITING_AUTHORITY'
local preview_camera = nil
local preview_ped = nil
local preview_appearance = nil
local preview_focus_active = false
local active_spawn_uuid = nil
local loadscreen_shutdown = false
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

local function send_loadscreen_phase(phase, correlation_id)
    if not CNR_UI_LIFECYCLE_CONTRACT.is_valid_phase(phase) then
        return
    end
    SendLoadingScreenMessage(json.encode({
        version = 1,
        type = 'ui.lifecycle.phase',
        payload = {
            contract_version = CNR_UI_LIFECYCLE_CONTRACT.version,
            phase = phase,
            retryable = false,
            correlation_id = correlation_id or 'awaiting-server-authority',
        },
    }))
end

local function shutdown_loadscreen()
    if loadscreen_shutdown then
        return
    end
    loadscreen_shutdown = true
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end

CreateThread(function()
    send_loadscreen_phase('SESSION_PENDING', 'awaiting-server-authority')
end)

RegisterNUICallback('close', function(_, callback)
    if lifecycle_locked then
        callback({ ok = false, locked = true })
        return
    end
    set_focus(nil)
    callback({ ok = true })
end)
RegisterNUICallback('inventory.documentClose', function(_, callback)
    set_focus(document_previous_focus)
    document_previous_focus = nil
    callback({ ok = true })
end)
RegisterNUICallback('inventory.actionComplete', function(payload, callback)
    local effect = type(payload) == 'table' and payload.effect or nil
    local known_effect = effect == 'DRINK_WATER'
        or effect == 'EAT_FOOD'
        or effect == 'INSPECT_STATE_ID'
        or effect == 'SHOW_STATE_ID'
        or effect == 'OPEN_TABLET'
    if not known_effect then
        callback({ ok = false })
        return
    end
    local keep_document = effect == 'INSPECT_STATE_ID' and focus_owner == 'inventoryDocument'
    local keep_tablet = effect == 'OPEN_TABLET' and focus_owner == 'tablet'
    if not keep_document and not keep_tablet then
        set_focus(nil)
    end
    callback({ ok = true })
end)
RegisterNUICallback('uiReady', function(_, callback)
    TriggerServerEvent('cnr:ui:ready')
    callback({ ok = true })
end)
RegisterNUICallback('lifecycleRefresh', function(payload, callback)
    if
        type(payload) ~= 'table'
        or payload.contract_version ~= CNR_UI_LIFECYCLE_CONTRACT.version
    then
        callback({ ok = false })
        return
    end
    for key in pairs(payload) do
        if key ~= 'contract_version' then
            callback({ ok = false })
            return
        end
    end
    TriggerServerEvent('cnr:ui:refresh')
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

local pending_inventory = {}
local function inventory_request(action, payload, callback)
    local request_id = payload and payload.request_id
    if type(request_id) ~= 'string' or request_id == '' or pending_inventory[request_id] then
        callback({
            ok = false,
            error = {
                code = 'VALIDATION_ERROR',
                message_key = 'inventory.error.invalid_request',
            },
        })
        return
    end
    pending_inventory[request_id] = {
        action = action,
        event = 'inventory.' .. action,
    }
    expire_pending(pending_inventory, request_id)
    TriggerServerEvent('cnr:inventory:request', action, payload)
    callback({ ok = true, queued = true, request_id = request_id })
end
for _, callback_name in ipairs({ 'snapshot', 'workspace', 'reposition', 'transfer', 'use' }) do
    RegisterNUICallback('inventory.' .. callback_name, function(payload, callback)
        inventory_request(callback_name, payload, callback)
    end)
end
RegisterNetEvent('cnr:inventory:response', function(action, request_id, result)
    local pending = pending_inventory[request_id]
    if pending and pending.action == action then
        pending_inventory[request_id] = nil
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

local pending_banking = {}
local function banking_request(action, payload, callback)
    local request_id = payload and payload.request_id
    if type(request_id) ~= 'string' or request_id == '' or pending_banking[request_id] then
        callback({
            ok = false,
            error = {
                code = 'VALIDATION_ERROR',
                message_key = 'banking.error.invalid_request',
            },
        })
        return
    end
    pending_banking[request_id] = action
    expire_pending(pending_banking, request_id)
    TriggerServerEvent('cnr:banking:request', action, payload)
    callback({ ok = true, queued = true, request_id = request_id })
end
for _, action in ipairs({ 'snapshot', 'transfer', 'atmCash' }) do
    RegisterNUICallback('banking.' .. action, function(payload, callback)
        banking_request(action, payload, callback)
    end)
end
RegisterNetEvent('cnr:banking:response', function(action, request_id, result)
    if pending_banking[request_id] == action then
        pending_banking[request_id] = nil
        SendNUIMessage({
            version = 1,
            type = 'ui.request.response',
            payload = {
                event = 'banking.' .. action,
                request_id = request_id,
                result = result,
            },
        })
    end
end)

local active_atms = {}
local pending_atm_open = nil

local function atm_request_id(prefix)
    return ('%s-%d-%d'):format(prefix, GetGameTimer(), GetPlayerServerId(PlayerId()))
end

local function request_atm_directory()
    TriggerServerEvent('cnr:banking:atmDirectoryRequest', {
        request_id = atm_request_id('atm-directory'),
        contract_version = 1,
    })
end

RegisterNetEvent('cnr:banking:atmDirectory', function(result)
    if
        type(result) ~= 'table'
        or result.ok ~= true
        or type(result.data) ~= 'table'
        or result.data.contract_version ~= 1
        or type(result.data.atms) ~= 'table'
    then
        return
    end
    local validated = {}
    for _, atm in ipairs(result.data.atms) do
        if
            type(atm) == 'table'
            and type(atm.atm_uuid) == 'string'
            and type(atm.label) == 'string'
            and tonumber(atm.x)
            and tonumber(atm.y)
            and tonumber(atm.z)
            and tonumber(atm.interaction_radius)
        then
            validated[#validated + 1] = atm
        end
    end
    active_atms = validated
end)

RegisterNetEvent('cnr:banking:atmDirectoryChanged', function()
    if not lifecycle_locked then
        request_atm_directory()
    end
end)

local function open_atm(atm)
    if lifecycle_locked or focus_owner or pending_atm_open then
        return
    end
    local request_id = atm_request_id('atm-open')
    pending_atm_open = request_id
    TriggerServerEvent('cnr:banking:atmOpenRequest', {
        atm_uuid = atm.atm_uuid,
        request_id = request_id,
        contract_version = 1,
    })
    SetTimeout(request_timeout_ms, function()
        if pending_atm_open == request_id then
            pending_atm_open = nil
        end
    end)
end

RegisterNetEvent('cnr:banking:atmOpenResponse', function(request_id, result)
    if request_id ~= pending_atm_open then
        return
    end
    pending_atm_open = nil
    if type(result) ~= 'table' or result.ok ~= true or type(result.data) ~= 'table' then
        local code = result and result.error and result.error.code or 'INTERNAL_ERROR'
        local reference = result and result.error and result.error.correlation_id or 'unavailable'
        TriggerEvent('chat:addMessage', {
            color = { 239, 91, 91 },
            args = {
                'CNR Banking',
                ('The ATM could not be opened (%s). Reference: %s'):format(code, reference),
            },
        })
        return
    end
    set_focus('atm')
    SendNUIMessage({
        version = 1,
        type = 'ui.atm.open',
        payload = result.data,
    })
end)

local function distance_to_atm(coordinates, atm)
    local delta_x = coordinates.x - tonumber(atm.x)
    local delta_y = coordinates.y - tonumber(atm.y)
    local delta_z = coordinates.z - tonumber(atm.z)
    return math.sqrt(delta_x * delta_x + delta_y * delta_y + delta_z * delta_z)
end

local function nearest_usable_atm()
    local ped = PlayerPedId()
    if ped == 0 then
        return nil
    end
    local coordinates = GetEntityCoords(ped)
    local nearest = nil
    local nearest_distance = nil
    for _, atm in ipairs(active_atms) do
        local distance = distance_to_atm(coordinates, atm)
        if not nearest_distance or distance < nearest_distance then
            nearest = atm
            nearest_distance = distance
        end
    end
    if
        nearest
        and nearest_distance
        and nearest_distance <= tonumber(nearest.interaction_radius)
    then
        return nearest, nearest_distance
    end
    return nil
end

local function show_atm_help()
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName('Press ~INPUT_CONTEXT~ to use the ATM')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

RegisterCommand('cnr_atm_open', function()
    local atm = nearest_usable_atm()
    if atm then
        open_atm(atm)
    end
end, false)

local function play_inventory_animation(dictionary, animation)
    CreateThread(function()
        RequestAnimDict(dictionary)
        local deadline = GetGameTimer() + 5000
        while not HasAnimDictLoaded(dictionary) and GetGameTimer() < deadline do
            Wait(0)
        end
        if not HasAnimDictLoaded(dictionary) then
            return
        end
        local ped = PlayerPedId()
        if ped ~= 0 and not IsEntityDead(ped) then
            TaskPlayAnim(ped, dictionary, animation, 4.0, -4.0, 3000, 49, 0.0, false, false, false)
        end
        RemoveAnimDict(dictionary)
    end)
end

RegisterNetEvent('cnr:inventory:item_effect', function(effect)
    if effect == 'DRINK_WATER' then
        play_inventory_animation('mp_player_intdrink', 'loop_bottle')
    elseif effect == 'EAT_FOOD' then
        play_inventory_animation('mp_player_inteat@burger', 'mp_player_int_eat_burger')
    elseif effect == 'OPEN_TABLET' then
        set_focus('tablet')
        SendNUIMessage({
            version = 1,
            type = 'ui.tablet.open',
            payload = { contract_version = 1 },
        })
    end
end)

RegisterNetEvent('cnr:inventory:document', function(presentation)
    if
        type(presentation) ~= 'table'
        or presentation.contract_version ~= 5
        or (presentation.mode ~= 'INSPECTED' and presentation.mode ~= 'PRESENTED')
        or type(presentation.document) ~= 'table'
    then
        return
    end
    document_previous_focus = presentation.mode == 'PRESENTED' and focus_owner or nil
    set_focus('inventoryDocument')
    SendNUIMessage({
        version = 1,
        type = 'ui.inventory.document',
        payload = presentation,
    })
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

local function complete_lifecycle()
    lifecycle_locked = false
    lifecycle_phase = 'RELEASED'
    destroy_preview_scene()
    release_player()
    set_focus(nil)
    SendNUIMessage({ version = 1, type = 'ui.shell.close', payload = {} })
    shutdown_loadscreen()
end

RegisterNetEvent('cnr:characters:lifecycleReady', function()
    complete_lifecycle()
end)

RegisterNetEvent('cnr:ui:lifecycle', function(snapshot)
    if
        type(snapshot) ~= 'table'
        or snapshot.contract_version ~= CNR_UI_LIFECYCLE_CONTRACT.version
        or not CNR_UI_LIFECYCLE_CONTRACT.is_valid_phase(snapshot.phase)
        or type(snapshot.retryable) ~= 'boolean'
        or type(snapshot.correlation_id) ~= 'string'
        or snapshot.correlation_id == ''
    then
        return
    end
    send_loadscreen_phase(snapshot.phase, snapshot.correlation_id)
    if snapshot.phase == 'READY' then
        complete_lifecycle()
        return
    end
    lifecycle_locked = true
    lifecycle_phase = snapshot.phase
    hold_player(true)
    set_focus('playerLifecycle')
    SendNUIMessage({ version = 1, type = 'ui.lifecycle.open', payload = snapshot })
    Wait(0)
    shutdown_loadscreen()
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
    complete_lifecycle()
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
RegisterCommand('cnr_registration_open', function()
    lifecycle_locked = true
    lifecycle_phase = 'REGISTRATION_REQUIRED'
    hold_player(true)
    set_focus('playerLifecycle')
    SendNUIMessage({
        version = 1,
        type = 'ui.lifecycle.open',
        payload = {
            contract_version = 1,
            phase = 'REGISTRATION_REQUIRED',
            retryable = false,
            correlation_id = 'local-registration-smoke-test',
        },
    })
end, false)
RegisterCommand('cnr_inventory_open', function()
    if lifecycle_locked then
        return
    end
    set_focus('inventory')
    SendNUIMessage({
        version = 1,
        type = 'ui.inventory.open',
        payload = { contract_version = 5, view = 'personal' },
    })
end, false)
RegisterKeyMapping('cnr_inventory_open', 'Open personal inventory', 'keyboard', 'F2')
RegisterCommand('cnr_storage_open', function()
    if lifecycle_locked then
        return
    end
    set_focus('inventory')
    SendNUIMessage({
        version = 1,
        type = 'ui.inventory.open',
        payload = { contract_version = 5, view = 'storage' },
    })
end, false)
RegisterKeyMapping('cnr_storage_open', 'Open nearby personal locker', 'keyboard', 'F3')

CreateThread(function()
    while true do
        if not lifecycle_locked then
            request_atm_directory()
            Wait(15000)
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if not lifecycle_locked and not focus_owner then
            local nearest = nearest_usable_atm()
            if nearest then
                DrawMarker(
                    1,
                    tonumber(nearest.x),
                    tonumber(nearest.y),
                    tonumber(nearest.z) - 1.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.65,
                    0.65,
                    0.35,
                    229,
                    174,
                    62,
                    155,
                    false,
                    false,
                    2,
                    false,
                    nil,
                    nil,
                    false
                )
                show_atm_help()
                if IsControlJustReleased(0, 38) then
                    open_atm(nearest)
                end
                Wait(0)
            else
                Wait(250)
            end
        else
            Wait(250)
        end
    end
end)

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
