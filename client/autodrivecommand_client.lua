local isAutopilotActive = false
local blip = nil
local STOP_DISTANCE = 12.0

local BuckoConfig = BuckoConfig or {
    EnableDrivingAutopilot = true,
	EnableWalkingAutopilot = true,
}

RegisterCommand("autodrive", function()
    TriggerServerEvent("tuner:checkAutopilotPermission")
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

RegisterCommand("stopautodrive", function()
    StopAutopilot()
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

        if blockVehicleEntryThread then
            TerminateThread(blockVehicleEntryThread)
        end
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