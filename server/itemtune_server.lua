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
