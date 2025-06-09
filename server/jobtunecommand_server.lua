local QBCore = exports['qb-core']:GetCoreObject()

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
        description = "Some vehicles need the tune to be applied multiple times before getting the OBD to send the file to the ECU, check your HUD for visual cues.",
        type = "inform",
        duration = 7000
    })

    TriggerClientEvent('zaps:jobTunerAttempt', src)
end, false)
