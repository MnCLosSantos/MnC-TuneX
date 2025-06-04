local QBCore = exports['qb-core']:GetCoreObject()

local function notifyClient(src, message, type)
    TriggerClientEvent('ox_lib:notify', src, {
        title = "TuneX",
        description = message,
        type = type or "error",
        duration = 3000,
        position = "top",
        progress = false,
    })
end

QBCore.Commands.Add('admintune', 'Apply TuneX tune to current vehicle (Admin only)', {}, false, function(source, args)
    local src = source
    if src == 0 then return end -- prevent console use

    -- Server side permission check: ONLY allow admin group
    local hasPermission = QBCore.Functions.HasPermission(src, "admin")
    if not hasPermission then
        notifyClient(src, "You do not have permission to use this command.", "error")
        return
    end

    -- If permission passes, trigger client event to start tuning progress bar etc
    TriggerClientEvent('zaps:adminTunerAttempt', src)
end)
