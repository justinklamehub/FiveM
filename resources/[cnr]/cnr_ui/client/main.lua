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
