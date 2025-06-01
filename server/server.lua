local QBCore = exports['qb-core']:GetCoreObject()

-- Handle tunerchip usage
QBCore.Functions.CreateUseableItem("tunerchip", function(source, item)
    TriggerClientEvent("zaps:useTunerChip", source)
end)

-- Handle tunerlaptop (must be used after tunerchip)
QBCore.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    local laptop = Player.Functions.GetItemByName("tunerdrive")
    if laptop and laptop.amount > 0 then
        TriggerClientEvent("zaps:useChip", source)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = "Missing Tool",
            description = "You need a TuneX Tunes Database to start tuning.",
            type = "error"
        })
    end
end)

-- Remove tunerchip from inventory
RegisterNetEvent("zaps:removeTunerChip", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem("tunerchip", 1)
end)

-- Job-based tuning (fully independent from item flow)
RegisterCommand('jobtune', function(source, args, rawCommand)
    if source == 0 then return end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local job = Player.PlayerData.job.name
    if not (job == "police" or job == "ambulance" or job == "trackmarshall") then
        TriggerClientEvent('ox_lib:notify', src, {
            title = "Wrong Job",
            description = "You need to be an emergency service to use the TuneX plugin command.",
            type = "error",
            duration = 7000
        })
        return
    end

    TriggerClientEvent('ox_lib:notify', src, {
        title = "TuneX",
        description = "The jobtune command needs to be used twice to work, check your HUD for visual cues.",
        type = "inform",
        duration = 7000
    })

    TriggerClientEvent('zaps:jobTunerAttempt', src)
end, false)
