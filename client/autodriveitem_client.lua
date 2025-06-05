local isAutopilotActive = false
local blip = nil
local STOP_DISTANCE = 12.0
local installedKits = {}

local BuckoConfig = BuckoConfig or {
    EnableDrivingAutopilot = true,
    EnableWalkingAutopilot = false,
}

RegisterNetEvent("tuner:useAutodriveKit", function()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        lib.notify({ title = "TuneX Autodrive", description = "You must be in a vehicle.", type = "error" })
        return
    end

    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do Wait(0) end
    TaskPlayAnim(ped, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 1, 0, false, false, false)

    lib.progressBar({
        duration = 5000,
        label = "Installing Autodrive Kit...",
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, mouse = false, combat = true }
    })

    ClearPedTasks(ped)

    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle then
        local plate = QBCore.Functions.GetPlate(vehicle)
        installedKits[plate] = true
    end

    TriggerServerEvent("tuner:applyAutodriveKit")
    lib.notify({ title = "TuneX Autodrive", description = "Autodrive kit installed!", type = "success" })
end)

RegisterNUICallback("tuner:checkAutopilotStart", function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not installedKits[plate] then
        lib.notify({ title = "TuneX Autodrive", description = "No AutoDrive Installed", type = "error" })
        cb(false)
        return
    end
    TriggerEvent("tuner:startAutopilot")
    cb(true)
end)

RegisterNUICallback("tuner:checkAutopilotStop", function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not installedKits[plate] then
        lib.notify({ title = "TuneX Autodrive", description = "No AutoDrive Installed", type = "error" })
        cb(false)
        return
    end
    StopAutopilot()
    cb(true)
end)

RegisterNetEvent("tuner:startAutopilot", function()
    if isAutopilotActive then
        lib.notify({ title = "TuneX Autopilot", description = "Autopilot is already active.", type = "inform" })
        return
    end

    local ped = PlayerPedId()
    blip = GetFirstBlipInfoId(8)

    if not DoesBlipExist(blip) then
        lib.notify({ title = "TuneX Autopilot", description = "Please set a GPS waypoint.", type = "error" })
        return
    end

    local dest = GetBlipInfoIdCoord(blip)
    isAutopilotActive = true

    if IsPedInAnyVehicle(ped, false) then
        if not BuckoConfig.EnableDrivingAutopilot then
            lib.notify({ title = "TuneX Autopilot", description = "Driving autopilot is disabled.", type = "error" })
            isAutopilotActive = false
            return
        end

        local vehicle = GetVehiclePedIsIn(ped, false)
        TaskVehicleDriveToCoordLongrange(ped, vehicle, dest.x, dest.y, dest.z, 30.0, 786603, 10.0)
        lib.notify({ title = "TuneX Autopilot", description = "Driving to your waypoint...", type = "success" })
        DriveToWaypoint(ped, vehicle, dest)
    else
        if not BuckoConfig.EnableWalkingAutopilot then
            lib.notify({ title = "TuneX Autopilot", description = "Walking autopilot is disabled.", type = "error" })
            isAutopilotActive = false
            return
        end

        lib.notify({ title = "TuneX Autopilot", description = "Walking to your waypoint...", type = "success" })
        WalkToWaypointSafely(ped, dest)
    end
end)

function StopAutopilot()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        ClearPedTasks(ped)
        SetVehicleHandbrake(vehicle, false)
        SetDriveTaskCruiseSpeed(ped, 0.0)
        SetEntityVelocity(vehicle, 0.0, 0.0, 0.0)
        Wait(100)
    else
        ClearPedTasks(ped)
    end
    isAutopilotActive = false
    blip = nil
    lib.notify({ title = "TuneX Autopilot", description = "Autopilot deactivated. You now have control.", type = "inform" })
end

function WalkToWaypointSafely(ped, destination)
    CreateThread(function()
        local arrived = false
        ClearPedTasks(ped)
        local blockVehicleEntryThread = CreateThread(function()
            while isAutopilotActive and not arrived do
                if IsPedTryingToEnterALockedVehicle(ped) or IsPedGettingIntoAVehicle(ped) then
                    ClearPedTasks(ped)
                end
                Wait(200)
            end
        end)

        while isAutopilotActive and not arrived do
            local pedCoords = GetEntityCoords(ped)
            local distance = #(destination - pedCoords)

            if distance < STOP_DISTANCE then
                ClearPedTasks(ped)
                isAutopilotActive = false
                blip = nil
                lib.notify({ title = "TuneX Autopilot", description = "Arrived at destination.", type = "success" })
                arrived = true
                break
            end

            TaskFollowNavMeshToCoord(ped, destination.x, destination.y, destination.z, 1.0, -1, 0.0, 0, 0.0)
            Wait(1000)
        end

        if blockVehicleEntryThread then TerminateThread(blockVehicleEntryThread) end
    end)
end

function DriveToWaypoint(ped, vehicle, destination)
    CreateThread(function()
        local arrived = false
        while isAutopilotActive and not arrived do
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(destination - vehCoords)

            if distance < STOP_DISTANCE then
                ClearPedTasks(ped)
                isAutopilotActive = false
                blip = nil
                lib.notify({ title = "TuneX Autopilot", description = "Arrived at destination.", type = "success" })
                arrived = true
                break
            end

            Wait(1000)
        end
    end)
end
