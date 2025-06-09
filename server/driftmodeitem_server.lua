local QBCore = exports['qb-core']:GetCoreObject()
local oxmysql = exports.oxmysql

QBCore.Functions.CreateUseableItem("driftkit", function(source)
    TriggerClientEvent('Tuner:client:useDriftKit', source)
end)

RegisterNetEvent('Tuner:server:checkAndInstallDriftKit', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    oxmysql:query('SELECT * FROM driftkits WHERE plate = ?', { plate }, function(result)
        if result[1] then
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Tuner",
                description = "Drift kit is already installed on this vehicle.",
                type = "error",
            })
            return
        end

        local removed = Player.Functions.RemoveItem("driftkit", 1)
        if removed then
            oxmysql:insert('INSERT INTO driftkits (plate, installed) VALUES (?, ?)', { plate, true })
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Tuner",
                description = "Drift kit installed successfully!",
                type = "success",
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Tuner",
                description = "Failed to remove drift kit from inventory.",
                type = "error",
            })
        end
    end)
end)

RegisterNetEvent('Tuner:server:removeDriftKit', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    oxmysql:query('SELECT * FROM driftkits WHERE plate = ?', { plate }, function(result)
        if not result[1] then
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Tuner",
                description = "No drift kit installed.",
                type = "error",
            })
            return
        end

        oxmysql:execute('DELETE FROM driftkits WHERE plate = ?', { plate })
        Player.Functions.AddItem("driftkit", 1)

        TriggerClientEvent('ox_lib:notify', src, {
            title = "Tuner",
            description = "Drift kit removed and returned to inventory.",
            type = "success",
        })
    end)
end)

QBCore.Functions.CreateCallback('Tuner:server:checkDriftKitInstalled', function(source, cb, plate)
    oxmysql:query('SELECT * FROM driftkits WHERE plate = ?', { plate }, function(result)
        cb(result[1] ~= nil)
    end)
end)
