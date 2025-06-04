local function notify(data)
    lib.notify(data)
end

RegisterNetEvent("zaps:jobTunerAttempt", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        notify({
            title = "TuneX",
            description = "You must be inside a vehicle to use this command.",
            type = "error"
        })
        return
    end

    local vehicleClass = GetVehicleClass(veh)
    if vehicleClass ~= 18 then
        notify({
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
        notify({
            title = "TuneX",
            description = "TuneX uploaded the file successfully to the ECU.",
            type = "success"
        })
    else
        notify({
            title = "TuneX",
            description = "Canceled applying the tune due to bad OBD connection. Try again.",
            type = "error"
        })
    end
end)
