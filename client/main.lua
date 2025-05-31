RegisterNetEvent('zaps:jobTunerAttempt', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        lib.notify({
            title = "TuneX",
            description = "You must be inside a vehicle to use this command.",
            type = "error"
        })
        return
    end

    local vehicleClass = GetVehicleClass(veh)
    if vehicleClass ~= 18 then
        lib.notify({
            title = "TuneX",
            description = "Only emergency vehicles (class 18) can be tuned with this command.",
            type = "error"
        })
        return
    end

    -- Proceed with tuning animation and ECU update
    TriggerEvent('zaps:useChip')
end)


RegisterNetEvent("zaps:useChip", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        lib.notify({
            title = "TuneX",
            description = "You must be inside a vehicle to upload the tune.",
            type = "error"
        })
        return
    end

    local prop = nil
    local model = `prop_cs_tablet`

    -- Load model and animation
    RequestModel(model)
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
    while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
        Wait(0)
    end

    -- Play animation
    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Create and attach tablet prop
    local coords = GetEntityCoords(ped)
    prop = CreateObject(model, coords.x, coords.y, coords.z + 0.2, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, true, true, false, true, 1, true)

    -- Progress bar
    local success = lib.progressBar({
        duration = 5000,
        label = 'Adding Tune via TuneX plugin...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    -- Cleanup
    ClearPedTasks(ped)
    if DoesEntityExist(prop) then
        DeleteEntity(prop)
    end

    if success then
        -- ✅ Apply the tuner chip
        TriggerEvent("zaps:tunerChipApplied") -- Replace with your actual logic/event
        lib.notify({
            title = "TuneX",
            description = "TuneX uploaded the file successfully to the ECU.",
            type = "success"
        })
    else
        -- ❌ Cancelled
        lib.notify({
            title = "TuneX",
            description = "Canceled applying the tune due to bad OBD connection. Try again.",
            type = "error"
        })
    end
end)


AddEventHandler('zaps:useChip', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle and vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        local speed = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
        local vehicleClass = GetVehicleClass(vehicle)
        local speedModifier = Config.SpeedModifiers[tostring(vehicleClass)]
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel', speed + speedModifier)
        lib.notify({
            title = 'TuneX',
            description = string.format(Locales[Config.Locale]['chip_used'], plate),
            position = 'topright',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
            },
            icon = 'speedometer',
            iconColor = '#29a329'
        })

    end
end)


if Config.UsePlateChangeCommand then 
RegisterCommand('changeplate', function()
    local input = lib.inputDialog('Change Plate', { {type = 'input', label = 'Enter your plate', required = true, min = 1, max = 8} })

    if not input or not input[1] then
        lib.notify({
            title = 'Change Plate',
            description = 'No plate entered.',
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
            },
            icon = 'times',
            iconColor = '#C53030'
        })
        return
    end
    local lowerInput = string.lower(input[1])
    for _, word in ipairs(Config.PlateBlacklist) do
        if string.find(lowerInput, word) then
            lib.notify({
                title = 'Change Plate',
                description = 'Inappropriate Text (Blacklisted).',
                position = 'top',
                style = {
                    backgroundColor = '#141517',
                    color = '#C1C2C5',
                },
                icon = 'times',
                iconColor = '#C53030'
            })
            return
        end
    end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle and vehicle ~= 0 then
        SetVehicleNumberPlateText(vehicle, input[1])
        lib.notify({
            title = 'Change Plate',
            description = 'Plate changed successfully.',
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
            },
            icon = 'check',
            iconColor = '#29a329'
        })
    else
        lib.notify({
            title = 'Change Plate',
            description = 'You are not in a vehicle.',
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
            },
            icon = 'times',
            iconColor = '#C53030'
        })
    end
end, false)
end