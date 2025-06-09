local QBCore = exports['qb-core']:GetCoreObject()

-- Register autodrivekit use
QBCore.Functions.CreateUseableItem("autodrivekit", function(source, item)
    TriggerClientEvent("tuner:useAutodriveKit", source)
end)

-- Save to DB on apply
RegisterServerEvent("tuner:applyAutodriveKit", function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not plate then return end

    exports.oxmysql:execute('REPLACE INTO tuner_autodrive_kits (plate, installed) VALUES (?, ?)', {plate, true})

    if Player.Functions.RemoveItem("autodrivekit", 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["autodrivekit"], "remove")
    end
end)

-- Remove from DB on uninstall
RegisterServerEvent("tuner:removeAutoDriveKit", function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not plate then return end

    exports.oxmysql:execute('DELETE FROM tuner_autodrive_kits WHERE plate = ?', {plate})

    Player.Functions.AddItem("autodrivekit", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["autodrivekit"], "add")
end)

-- Fetch kits for player when they enter vehicle
QBCore.Functions.CreateCallback("tuner:hasAutodriveKit", function(source, cb, plate)
    exports.oxmysql:fetch('SELECT * FROM tuner_autodrive_kits WHERE plate = ?', {plate}, function(result)
        cb(result[1] ~= nil)
    end)
end)
