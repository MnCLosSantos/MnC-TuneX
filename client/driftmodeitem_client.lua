local QBCore = exports['qb-core']:GetCoreObject()
local isRemovingDriftKit = false
local driftMode = false

RegisterNetEvent('Tuner:client:useDriftKit', function()
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        lib.notify({
            title = "TuneX",
            description = "You must be in a vehicle to use the drift kit.",
            type = "error",
        })
        return
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    local plate = QBCore.Functions.GetPlate(vehicle)

    QBCore.Functions.TriggerCallback('Tuner:server:checkDriftKitInstalled', function(alreadyInstalled)
        if alreadyInstalled then
            lib.notify({
                title = "TuneX",
                description = "Drift kit is already installed on this vehicle.",
                type = "error",
            })
            return
        end

        -- Load mechanic animation
        RequestAnimDict("mini@repair")
        while not HasAnimDictLoaded("mini@repair") do
            Wait(100)
        end
        TaskPlayAnim(ped, "mini@repair", "fixing_a_player", 8.0, -8.0, -1, 1, 0, false, false, false)

        -- Start ox_lib progress bar
        local success = lib.progressBar({
            duration = 10000,
            label = "Installing TuneX Drift Mode Kit...",
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true,
            }
        })

        ClearPedTasks(ped)

        if success then
            TriggerServerEvent('Tuner:server:checkAndInstallDriftKit', plate)
        else
            lib.notify({
                title = "TuneX",
                description = "Installation cancelled.",
                type = "error",
            })
        end
    end, plate)
end)

RegisterNUICallback('toggleDriftMode', function(data, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if not vehicle or vehicle == 0 then
        lib.notify({
            title = "TuneX",
            description = "You must be in a vehicle.",
            type = "error"
        })
        cb({})
        return
    end

    local plate = QBCore.Functions.GetPlate(vehicle)

    QBCore.Functions.TriggerCallback('Tuner:server:checkDriftKitInstalled', function(installed)
        if not installed then
            lib.notify({
                title = "TuneX",
                description = "No drift kit installed.",
                type = "error"
            })
            cb({})
            return
        end

        -- Drift kit is installed, toggle drift mode
        if driftMode then
            TriggerEvent('Tuner:client:removeDriftMode')
            driftMode = false
        else
            TriggerEvent('Tuner:client:applyDriftMode')
            driftMode = true
        end

        cb('ok')
    end, plate)
end)


RegisterNUICallback('removeDriftKit', function(_, cb)
    if isRemovingDriftKit then return end
    isRemovingDriftKit = true

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle or vehicle == 0 then
        lib.notify({ title = "TuneX", description = "You must be in a vehicle.", type = "error" })
        isRemovingDriftKit = false
        cb({})
        return
    end

    local plate = QBCore.Functions.GetPlate(vehicle)
    QBCore.Functions.TriggerCallback('Tuner:server:checkDriftKitInstalled', function(installed)
        if not installed then
            lib.notify({ title = "TuneX", description = "No drift kit installed.", type = "error" })
            isRemovingDriftKit = false
            cb({})
            return
        end

        -- Close UI
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "hideUI" })

        -- Animation
        RequestAnimDict("mini@repair")
        while not HasAnimDictLoaded("mini@repair") do Wait(100) end
        TaskPlayAnim(ped, "mini@repair", "fixing_a_player", 8.0, -8.0, -1, 1, 0, false, false, false)

        -- Progress bar
        local success = lib.progressBar({
            duration = 10000,
            label = "Removing TuneX Drift Mode Kit...",
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true
            }
        })

        ClearPedTasks(ped)

        if success then
            TriggerServerEvent('Tuner:server:removeDriftKit', plate)
            TriggerEvent('Tuner:client:removeDriftMode') -- reset drift mode client-side handling
        else
            lib.notify({
                title = "TuneX",
                description = "Removal cancelled.",
                type = "error"
            })
        end

        driftMode = false
        isRemovingDriftKit = false
        cb({})
    end, plate)
end)

