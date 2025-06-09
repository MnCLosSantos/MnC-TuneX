local QBCore = exports['qb-core']:GetCoreObject()

local driftMode = false

-- Logic to apply drift mode (previously your command and event)
RegisterNetEvent('Tuner:client:applyDriftMode', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(vehicle, -1) == ped then
            local modifier = 1

            if GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff") > 90 then
                driftMode = true 
            else 
                driftMode = false 
            end

            if driftMode then modifier = -1 end

            for _, value in ipairs(Config.handleMods) do
                SetVehicleHandlingFloat(vehicle, "CHandlingData", value[1],
                    GetVehicleHandlingFloat(vehicle, "CHandlingData", value[1]) + value[2] * modifier)
            end

            if driftMode then
                lib.notify({
                    title = 'Tuner',
                    description = "Drift Mode: OFF. Enjoy standard handling!",
                    type = 'success',
                    duration = 3000
                })
            else
                lib.notify({
                    title = 'Tuner',
                    description = "Drift Mode: ON. Enjoy sliding sideways!",
                    type = 'success',
                    duration = 3000
                })
            end

            if GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff") < 90 then
                SetVehicleEnginePowerMultiplier(vehicle, 0.0)
            else
                if GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveBiasFront") == 0 then
                    SetVehicleEnginePowerMultiplier(vehicle, 190.0)
                else
                    SetVehicleEnginePowerMultiplier(vehicle, 100.0)
                end
            end
        else
            lib.notify({
                title = 'Tuner',
                description = "You must be the driver to enable drift mode.",
                type = 'error',
                duration = 2500
            })
        end
    else
        lib.notify({
            title = 'Tuner',
            description = "You must be in a vehicle to enable drift mode.",
            type = 'error',
            duration = 2500
        })
    end
end)

-- Logic to remove drift mode
RegisterNetEvent('Tuner:client:removeDriftMode', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(vehicle, -1) == ped then
            local modifier = -1

            for _, value in ipairs(Config.handleMods) do
                SetVehicleHandlingFloat(vehicle, "CHandlingData", value[1],
                    GetVehicleHandlingFloat(vehicle, "CHandlingData", value[1]) + value[2] * modifier)
            end

            SetVehicleEnginePowerMultiplier(vehicle, 0.0)

            lib.notify({
                title = 'Tuner',
                description = "Drift mode removed. Vehicle handling reset.",
                type = 'info',
                duration = 3000
            })
        else
            lib.notify({
                title = 'Tuner',
                description = "You must be the driver to remove drift mode.",
                type = 'error',
                duration = 2500
            })
        end
    else
        lib.notify({
            title = 'Tuner',
            description = "You must be in a vehicle to remove drift mode.",
            type = 'error',
            duration = 2500
        })
    end
end)
