local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("tunerchip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    TriggerClientEvent("zaps:useTunerChip", source)
end)

QBCore.Functions.CreateUseableItem("tunerdrive", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    TriggerClientEvent("zaps:useTunerDrive", source)
end)

QBCore.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    TriggerClientEvent("zaps:useTunerLaptop", source)
end)

QBCore.Functions.CreateCallback('zaps:hasItemInInventory', function(source, cb, itemName)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local count = Player.Functions.GetItemByName(itemName)
        if count ~= nil then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)


RegisterNetEvent('zaps:removeTunerChip', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem("tunerchip", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["tunerchip"], "remove")
    end
end)

RegisterNetEvent('tunerlaptop:server:removeTunerDrive', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem("tunerdrive", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["tunerdrive"], "remove")
    end
end)

RegisterNetEvent('zaps:returnTunerChip', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("tunerchip", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["tunerchip"], "add")
    end
end)

RegisterNetEvent('zaps:returnTunerDrive', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("tunerdrive", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["tunerdrive"], "add")
    end
end)

RegisterNetEvent('tunerlaptop:server:returnTunerDrive', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("tunerdrive", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["tunerdrive"], "add")
    end
end)

RegisterNetEvent('tunerlaptop:server:giveTunerDrive2', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("tunerdrive2", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["tunerdrive2"], "add")
    end
end)

RegisterNetEvent('zaps:removeTunerDrive2', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem('tunerdrive2', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['tunerdrive2'], 'remove')
    end
end)

-- Save plugin state to DB (chip, drive, tune)
RegisterNetEvent('zaps:saveVehiclePlugin', function(plate, plugin, state)
    if not plate or not plugin then return end
    if not (plugin == "chip" or plugin == "drive" or plugin == "tune") then return end

    exports.oxmysql:execute(
        'INSERT INTO vehicle_plugins (plate, ' .. plugin .. ') VALUES (?, ?) ON DUPLICATE KEY UPDATE ' .. plugin .. ' = ?',
        { plate, state, state }
    )
end)

-- Get plugin state from DB for a vehicle
QBCore.Functions.CreateCallback('zaps:getVehiclePlugins', function(source, cb, plate)
    if not plate then return cb({ chip = false, drive = false, tune = false }) end

    exports.oxmysql:fetch('SELECT chip, drive, tune FROM vehicle_plugins WHERE plate = ?', { plate }, function(result)
        if result and result[1] then
            cb(result[1])
        else
            cb({ chip = false, drive = false, tune = false })
        end
    end)
end)
