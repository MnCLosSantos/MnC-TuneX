local QBCore = exports['qb-core']:GetCoreObject()

-- Register autodrivekit item
QBCore.Functions.CreateUseableItem("autodrivekit", function(source, item)
    TriggerClientEvent("tuner:useAutodriveKit", source)
end)

-- Apply autodrivekit
RegisterServerEvent("tuner:applyAutodriveKit", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Player.Functions.RemoveItem("autodrivekit", 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["autodrivekit"], "remove")
    end
end)

