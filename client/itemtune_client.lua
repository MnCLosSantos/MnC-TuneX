local installedKits = {}
local appliedPlugIns = {}

local function getVehiclePlate(vehicle)
    return string.gsub(GetVehicleNumberPlateText(vehicle), "%s+", "")
end

RegisterNetEvent('zaps:useTunerChip', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        lib.notify({title = 'TuneX', description = 'You must be inside a vehicle to plug in the TuneX OBD device.', type = 'error'})
        return
    end

    local plate = getVehiclePlate(vehicle)
    appliedPlugIns[plate] = appliedPlugIns[plate] or {}

    if appliedPlugIns[plate].chip then
        lib.notify({title = 'TuneX', description = 'TuneX PlugIN is already connected to this vehicle.', type = 'error'})
        return
    end

    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do Wait(0) end
    TaskPlayAnim(ped, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 1, 0, false, false, false)

    local success = lib.progressBar({
        duration = 4000,
        label = 'Plugging in TuneX OBD Device...',
        useWhileDead = false,
        canCancel = true,
        disable = {car = true, move = true, combat = true},
    })

    ClearPedTasks(ped)

    if success then
        appliedPlugIns[plate].chip = true
        TriggerServerEvent('zaps:removeTunerChip')
		TriggerServerEvent("zaps:saveVehiclePlugin", plate, "chip", true)
        lib.notify({title = 'TuneX', description = 'TuneX OBD PlugIN connected', position = 'top', type = 'success', icon = 'plug'})
    else
        lib.notify({title = 'TuneX', description = 'Connection canceled. TuneX PlugIN not applied.', type = 'error'})
    end
end)

RegisterNetEvent('zaps:useTunerDrive', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        lib.notify({title = 'TuneX', description = 'You must be inside a vehicle to plug in the TuneX Drive device.', type = 'error'})
        return
    end

    local plate = getVehiclePlate(vehicle)
    appliedPlugIns[plate] = appliedPlugIns[plate] or {}

    -- Tablet animation
    local model = `prop_cs_tablet`
    RequestModel(model)
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
    while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do Wait(0) end

    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    local prop = CreateObject(model, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    local success = lib.progressBar({
        duration = 4000,
        label = 'Plugging in TuneX Drive device...',
        useWhileDead = false,
        canCancel = true,
        disable = {car = true, move = true, combat = true},
    })

    ClearPedTasks(ped)
    if DoesEntityExist(prop) then DeleteEntity(prop) end

    if success then
        appliedPlugIns[plate].drive = true
        TriggerServerEvent('tunerlaptop:server:removeTunerDrive')
		TriggerServerEvent("zaps:saveVehiclePlugin", plate, "drive", true)
        lib.notify({title = 'TuneX', description = 'TuneX Drive device connected', position = 'top', type = 'success', icon = 'plug'})
    else
        lib.notify({title = 'TuneX', description = 'Connection canceled. TuneX Drive device not applied.', type = 'error'})
    end
end)


RegisterNetEvent('zaps:useTunerLaptop', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        lib.notify({title = 'TuneX', description = 'You need to be in a vehicle to use the Interface.', type = 'error'})
        return
    end

    local plate = getVehiclePlate(vehicle)
    local plugs = appliedPlugIns[plate]

    if not plugs or (not plugs.chip and not plugs.drive) then
        lib.notify({title = 'TuneX', description = 'You must connect the TuneX PlugIN or Drive device before opening the laptop.', type = 'error'})
        return
    end

    local model = `prop_cs_tablet`
    RequestModel(model)
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
    while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do Wait(0) end

    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    local prop = CreateObject(model, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    local connectingSuccess = lib.progressBar({
        duration = 8000,
        label = 'Booting TuneX R69 Interface...',
        useWhileDead = false,
        canCancel = true,
        disable = {car = true, move = true, combat = true},
    })

    ClearPedTasks(ped)
    if DoesEntityExist(prop) then DeleteEntity(prop) end

    if not connectingSuccess then
        lib.notify({title = 'TuneX', description = 'Connection canceled. Cannot open TuneX PlugIN.', type = 'error'})
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({action = 'showUI'})
end)


RegisterNUICallback('uploadTune', function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        cb({})
        return
    end

    local plate = getVehiclePlate(vehicle)
    local plugs = appliedPlugIns[plate]

    if not plugs or not plugs.chip then
        lib.notify({title = 'TuneX', description = 'You must connect the TuneX PlugIN before uploading.', type = 'error'})
        cb({})
        return
    end

    -- Ask server if player has 'tunerdrive2' item
    QBCore.Functions.TriggerCallback('zaps:hasItemInInventory', function(hasItem)
        if not hasItem then
            lib.notify({title = 'TuneX', description = 'You need a Decrypted Drive in your inventory to upload.', type = 'error'})
            cb({})
            return
        end

        -- If has item, continue logic

        SetNuiFocus(false, false)
        SendNUIMessage({action = 'hideUI'})

        local model = `prop_cs_tablet`
        RequestModel(model)
        RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
        while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do Wait(0) end

        TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
        local prop = CreateObject(model, 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

        local success = lib.progressBar({
            duration = 5000,
            label = 'Uploading TuneX file via PlugIN...',
            useWhileDead = false,
            canCancel = true,
            disable = {car = true, move = true, combat = true},
        })

        ClearPedTasks(ped)
        if DoesEntityExist(prop) then DeleteEntity(prop) end

        if success then
            -- Remove tunerdrive2 from inventory on server
            TriggerServerEvent('zaps:removeTunerDrive2')
			TriggerEvent("zaps:tunerChipApplied")
			TriggerEvent("zaps:tunerChipApplied")
			TriggerEvent("zaps:tunerChipApplied")
			TriggerEvent("zaps:tunerChipApplied")
			TriggerServerEvent("zaps:saveVehiclePlugin", plate, "tune", true)
            lib.notify({title = 'TuneX', description = 'TuneX uploaded the file successfully to the ECU.', type = 'success'})
            Wait(500)
            SetNuiFocus(true, true)
            SendNUIMessage({action = 'showUI'})
        else
            lib.notify({title = 'TuneX', description = 'Canceled applying the tune due to bad OBD connection. Try again.', type = 'error'})
        end

        cb({})
    end, 'tunerdrive2') -- Pass the item name here
end)


RegisterNUICallback('disconnectOBD', function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then cb({}) return end

    local plate = getVehiclePlate(vehicle)
    if not appliedPlugIns[plate] or not appliedPlugIns[plate].chip then
        lib.notify({title = 'TuneX', description = 'No TuneX PlugIN is connected to disconnect.', type = 'error'})
        cb({}) return
    end

    -- Close UI first
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'hideUI'})

    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do Wait(0) end
    TaskPlayAnim(ped, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 1, 0, false, false, false)

    local success = lib.progressBar({
        duration = 10000,
        label = 'Disconnecting OBD PlugIN',
        useWhileDead = false,
        canCancel = true,
        disable = {car = true, move = true, combat = true},
    })

    ClearPedTasks(ped)

    if success then
        appliedPlugIns[plate].chip = nil
        TriggerServerEvent('zaps:returnTunerChip')
        lib.notify({title = 'TuneX', description = 'OBD PlugIN disconnected successfully.', type = 'inform'})
    end

    -- Reopen UI
    Wait(250)
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'showUI'})

    cb({})
end)

local function playTabletAnimation(ped)
    local model = `prop_cs_tablet`
    RequestModel(model)
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
    while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do Wait(0) end

    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    local prop = CreateObject(model, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    return prop
end

RegisterNUICallback('disconnectDrive', function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then cb({}) return end

    local plate = getVehiclePlate(vehicle)
    if not appliedPlugIns[plate] or not appliedPlugIns[plate].drive then
        lib.notify({title = 'TuneX', description = 'Encrypted Drive not inserted.', type = 'error'})
        cb({}) return
    end

    -- Close UI first
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'hideUI'})

    -- Play tablet animation
    local prop = playTabletAnimation(ped)

    local success = lib.progressBar({
        duration = 10000,
        label = 'Removing Encrypted Drive',
        useWhileDead = false,
        canCancel = true,
        disable = {car = true, move = true, combat = true},
    })

    ClearPedTasks(ped)
    if DoesEntityExist(prop) then DeleteEntity(prop) end

    if success then
        appliedPlugIns[plate].drive = nil
        TriggerServerEvent('tunerlaptop:server:returnTunerDrive')
        lib.notify({title = 'TuneX', description = 'Encrypted Drive Removed', type = 'success'})
    end

    -- Reopen UI
    Wait(250)
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'showUI'})

    cb({})
end)

RegisterNUICallback('decryptFiles', function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then cb({}) return end

    local plate = getVehiclePlate(vehicle)
    if not appliedPlugIns[plate] or not appliedPlugIns[plate].drive then
        lib.notify({title = 'TuneX', description = 'Encrypted Drive not inserted.', type = 'error'})
        cb({})
        return
    end

    -- Close the UI
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'hideUI'})

    -- Tablet animation
    local model = `prop_cs_tablet`
    RequestModel(model)
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
    while not HasModelLoaded(model) or not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do Wait(0) end

    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    local prop = CreateObject(model, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    -- Decryption progress bar
    local success = lib.progressBar({
        duration = 20000,
        label = 'Decryption in progress',
        useWhileDead = false,
        canCancel = true,
        disable = {car = true, move = true, combat = true},
    })

    ClearPedTasks(ped)
    if DoesEntityExist(prop) then DeleteEntity(prop) end

    if success then
        TriggerServerEvent('tunerlaptop:server:giveTunerDrive2')
        lib.notify({title = 'TuneX', description = 'Decryption complete. Decrypted drive received.', type = 'success'})
    else
        lib.notify({title = 'TuneX', description = 'Decryption canceled.', type = 'error'})
    end

    -- Reopen the UI and set focus back
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'showUI'})

    cb({})
end)


RegisterNUICallback('closeUI', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'hideUI'})
    cb({})
end)

RegisterCommand('escapeui', function()
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'hideUI'})
end)

RegisterKeyMapping('escapeui', 'Close TuneX UI (Escape)', 'keyboard', 'escape')

RegisterNetEvent('zaps:tunerChipApplied', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then return end

    local plate = getVehiclePlate(vehicle)
    local class = GetVehicleClass(vehicle)
    local modifier = Config.SpeedModifiers[tostring(class)]

    if not modifier then
        lib.notify({title = 'TuneX', description = 'This vehicle class is not supported for tuning.', type = 'error'})
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
end)

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local plate = QBCore.Functions.GetPlate(vehicle)

            if not installedKits[plate] then
                QBCore.Functions.TriggerCallback("zaps:getVehiclePlugins", function(data)
                    -- Ensure table exists
                    appliedPlugIns[plate] = appliedPlugIns[plate] or {}

                    if data.chip then
                        appliedPlugIns[plate].chip = true
                        -- lib.notify({ title = 'TuneX', description = 'Tuner Chip applied', type = 'success' })
                        -- Optional: trigger performance/handling logic
                    end

                    if data.drive then
                        appliedPlugIns[plate].drive = true
                    end

                    if data.tune then
                        appliedPlugIns[plate].tune = true
                        TriggerEvent("zaps:tunerChipApplied") -- i knowwww but blame gta the base game vehs take 6-15 attempts to apply...
						TriggerEvent("zaps:tunerChipApplied")
						TriggerEvent("zaps:tunerChipApplied")
						TriggerEvent("zaps:tunerChipApplied")
						TriggerEvent("zaps:tunerChipApplied")
                        -- ApplyHandlingMods(vehicle) -- if you want to have this defined
                    end

                    installedKits[plate] = true
                end, plate)
            end
        end
    end
end)

