local appliedVehicles = {}
local tunerDriveTaken = false
local tunedVehicles = {}

RegisterNetEvent('zaps:useTunerChip', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        lib.notify({
            title = 'TuneX',
            description = 'You must be inside a vehicle to plug in the TuneX OBD device.',
            type = 'error'
        })
        return
    end

    local plate = string.gsub(GetVehicleNumberPlateText(vehicle), "%s+", "")
    if appliedVehicles[plate] then
        lib.notify({
            title = 'TuneX',
            description = 'TuneX PlugIN is already connected to this vehicle.',
            type = 'error'
        })
        return
    end

    if tunedVehicles[plate] then
        lib.notify({
            title = 'TuneX',
            description = 'This vehicle has already been tuned. Tune reuse is not allowed.',
            type = 'error'
        })
        return
    end

    local dict = "mini@repair"
    local anim = "fixing_a_ped"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end

    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    local success = lib.progressBar({
        duration = 4000,
        label = 'Plugging in TuneX OBD Device...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    ClearPedTasks(ped)

    if success then
        appliedVehicles[plate] = true
        TriggerServerEvent('zaps:removeTunerChip')
        lib.notify({
            title = 'TuneX',
            description = 'TuneX OBD PlugIN connected',
            position = 'top',
            type = 'success',
            icon = 'plug',
        })
    else
        lib.notify({
            title = 'TuneX',
            description = 'Connection canceled. TuneX PlugIN not applied.',
            type = 'error'
        })
    end
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

    local plate = string.gsub(GetVehicleNumberPlateText(veh), "%s+", "")
    if not appliedVehicles[plate] then
        lib.notify({
            title = 'TuneX',
            description = 'You need to plug in the TuneX PlugIN.',
            type = 'error'
        })
        return
    end

    if tunedVehicles[plate] then
        lib.notify({
            title = 'TuneX',
            description = 'This vehicle has already been tuned.',
            type = 'error'
        })
        return
    end

    TriggerServerEvent('zaps:removeTunerDrive')
    tunerDriveTaken = true

    SetNuiFocus(true, true)
    SendNUIMessage({ action = "showUI" })
end)

RegisterNUICallback("uploadTune", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hideUI" })

    local ped = PlayerPedId()
    local prop = nil
    local model = `prop_cs_tablet`
    RequestModel(model)
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
    while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do Wait(0) end

    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    local coords = GetEntityCoords(ped)
    prop = CreateObject(model, coords.x, coords.y, coords.z + 0.2, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, true, true, false, true, 1, true)

    local success = lib.progressBar({
        duration = 5000,
        label = 'Uploading TuneX file...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    ClearPedTasks(ped)
    if DoesEntityExist(prop) then DeleteEntity(prop) end

    local plate = string.gsub(GetVehicleNumberPlateText(GetVehiclePedIsIn(ped, false)), "%s+", "")

    if success then
        TriggerEvent("zaps:tunerChipApplied")
        lib.notify({
            title = "TuneX",
            description = "TuneX uploaded the file successfully to the ECU.",
            type = "success"
        })

        tunedVehicles[plate] = true

        if tunerDriveTaken then
            TriggerServerEvent('zaps:returnTunerDrive')
            tunerDriveTaken = false
        end
    else
        lib.notify({
            title = "TuneX",
            description = "Canceled applying the tune due to bad OBD connection. Try again.",
            type = "error"
        })
    end

    cb({})
end)

RegisterNUICallback("closeUI", function(_, cb)
    SetNuiFocus(false, false)
    if tunerDriveTaken then
        TriggerServerEvent('zaps:returnTunerDrive')
        tunerDriveTaken = false
    end
    cb({})
end)

RegisterNetEvent("zaps:tunerChipApplied", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle or vehicle == 0 then return end

    local plate = string.gsub(GetVehicleNumberPlateText(vehicle), "%s+", "")
    local class = GetVehicleClass(vehicle)
    local modifier = Config.SpeedModifiers[tostring(class)]

    if not modifier then
        lib.notify({
            title = "TuneX",
            description = "This vehicle class is not supported for tuning.",
            type = "error"
        })
        return
    end

    for i = 1, 5 do
        Wait(250)
        local currentSpeed = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
        if currentSpeed > 0 then
            SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel', currentSpeed + modifier)
            break
        end
    end

    lib.notify({
        title = "TuneX",
        description = string.format(Locales[Config.Locale]['chip_used'], plate),
        position = 'top',
        icon = 'microchip',
        iconColor = '#00ff88'
    })
end)

RegisterNetEvent("zaps:jobTunerAttempt", function()
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

    local prop = nil
    local model = `prop_cs_tablet`
    RequestModel(model)
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
    while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do Wait(0) end

    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    local coords = GetEntityCoords(ped)
    prop = CreateObject(model, coords.x, coords.y, coords.z + 0.2, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, true, true, false, true, 1, true)

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

    ClearPedTasks(ped)
    if DoesEntityExist(prop) then DeleteEntity(prop) end

    if success then
        TriggerEvent("zaps:tunerChipApplied")
        lib.notify({
            title = "TuneX",
            description = "TuneX uploaded the file successfully to the ECU.",
            type = "success"
        })
    else
        lib.notify({
            title = "TuneX",
            description = "Canceled applying the tune due to bad OBD connection. Try again.",
            type = "error"
        })
    end
end)
