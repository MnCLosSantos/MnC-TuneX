local QBCore = exports['qb-core']:GetCoreObject()

local function notifyClient(src, message, type)
    TriggerClientEvent('ox_lib:notify', src, {
        title = "Tuner",
        description = message,
        type = type or "error",
        duration = 3000,
        position = "top",
        progress = false,
    })
end

-- Admin locked command to enable drift mode
QBCore.Commands.Add('driftmode', 'Toggle drift mode on current vehicle (Admin only)', {}, false, function(source, args)
    local src = source
    if src == 0 then return end -- prevent console use

    if not QBCore.Functions.HasPermission(src, "admin") then
        notifyClient(src, "You do not have permission to use this command.", "error")
        return
    end

    TriggerClientEvent('Tuner:client:applyDriftMode', src)
end)

-- Admin locked command to remove drift mode
QBCore.Commands.Add('removedrift', 'Remove drift mode from current vehicle (Admin only)', {}, false, function(source, args)
    local src = source
    if src == 0 then return end -- prevent console use

    if not QBCore.Functions.HasPermission(src, "admin") then
        notifyClient(src, "You do not have permission to use this command.", "error")
        return
    end

    TriggerClientEvent('Tuner:client:removeDriftMode', src)
end)
