local QBCore = exports['qb-core']:GetCoreObject()

-- Permission check for command
RegisterServerEvent("tuner:checkAutopilotPermission", function()
    local src = source
    local hasPermission =
        QBCore.Functions.HasPermission(src, "god") or
        QBCore.Functions.HasPermission(src, "admin") or
        QBCore.Functions.HasPermission(src, "mod")

    if hasPermission then
        TriggerClientEvent("tuner:startAutopilot", src)
    else
        TriggerClientEvent("ox_lib:notify", src, {
            title = "TuneX Autopilot",
            description = "You do not have permission to use this command.",
            type = "error"
        })
    end
end)
