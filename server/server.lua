local QBCore = exports['qb-core']:GetCoreObject()

    -- MNC edits below
QBCore.Functions.CreateUseableItem("tunerchip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    -- Check if player has the required tool item
    local laptop = Player.Functions.GetItemByName("tunerlaptop")

    if laptop and laptop.amount > 0 then
        -- ✅ Player has the tuner laptop, allow using the tuner chip
        TriggerClientEvent("zaps:useChip", source)
    else
        -- ❌ Missing required tool
        TriggerClientEvent('ox_lib:notify', source, {
            title = "Missing Tool",
            description = "You need a Tuner Laptop to use the TuneX plugin.",
            type = "error"
        })
    end
end)

-- Register the '/jobtunerchip' command with class 18 check
RegisterCommand('jobtune', function(source, args, rawCommand)
    if source == 0 then return end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local jobName = Player.PlayerData.job.name
    local allowedJobs = {
        bcso = true,
        police = true,
        ambulance = true
    }

    if not allowedJobs[jobName] then
        TriggerClientEvent('ox_lib:notify', src, {
            title = "Wrong Job",
            description = "You need to be an emergency service to use the TuneX plugin command.",
            type = "error",
            duration = 7000
        })
        return
    end

    -- Inform user of the two-step process
    TriggerClientEvent('ox_lib:notify', src, {
        title = "TuneX",
        description = "The jobtune command needs to be used twice to work, check your HUD for visual cues.",
        type = "inform",
        duration = 7000
    })

    -- Check vehicle class on client-side to avoid misuse
    TriggerClientEvent('zaps:jobTunerAttempt', src)
end, false)

