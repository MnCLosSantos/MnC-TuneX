local ABSSystemEnabled = true
local isABSActive = false
local pulseInterval = 50
local nextToggle = 0
local lockThreshold = 0.15
local brakeInputThreshold = 0.5
local rearPressureRatio = 0.7
local debug = false

local function debugPrint(msg)
    if debug then
        print(("[ABS] %s"):format(msg))
    end
end

-- Function to set brake pressure for all wheels
local function SetAllBrakePressure(veh, pressure)
    for w = 0, GetVehicleNumberOfWheels(veh) - 1 do
        SetVehicleWheelBrakePressure(veh, w, pressure)
    end
end

-- Handle toggle from NUI (called by your JS button POSTing toggleABS)
RegisterNUICallback('toggleABS', function(data, cb)
    if data.enabled ~= nil then
        ABSSystemEnabled = data.enabled

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if not ABSSystemEnabled then
            if isABSActive then
                SetAllBrakePressure(veh, 1.0)
                SendNUIMessage({ type = "abs", status = false })
                isABSActive = false
            end

            lib.notify({
                title = 'TuneX Anti-Lock Braking System',
                description = 'ABS Disabled',
                type = 'error'
            })
        else
            lib.notify({
                title = 'TuneX Anti-Lock Braking System',
                description = 'ABS Enabled',
                type = 'success'
            })
        end
    end
    cb('ok')
end)

CreateThread(function()
    while true do
        Wait(0)

        if not ABSSystemEnabled then
            goto cont
        end

        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            if isABSActive then
                local veh = GetVehiclePedIsIn(ped, false)
                SetAllBrakePressure(veh, 1.0)
                SendNUIMessage({ type = "abs", status = false })
                isABSActive = false
            end
            goto cont
        end

        local veh = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(veh, -1) ~= ped then
            goto cont
        end

        local speed = GetEntitySpeed(veh) * 3.6
        if speed < 5 then goto cont end

        local brakeInput = GetControlNormal(0, 72)
        local ebrakeInput = IsControlPressed(0, 44)

        local totalWS = 0.0
        for i = 0, 3 do totalWS = totalWS + GetVehicleWheelSpeed(veh, i) end
        local avgWS = (totalWS / 4) * 3.6
        local slip = (speed - avgWS) / math.max(speed, 1.0)

        debugPrint(("Speed: %.1f km/h | Slip: %.3f"):format(speed, slip))

        if (brakeInput >= brakeInputThreshold or ebrakeInput) and slip > lockThreshold then
            if not isABSActive then
                isABSActive = true
                nextToggle = GetGameTimer()
                SendNUIMessage({ type = "abs", status = true })
                debugPrint(">> ABS ENGAGED")
            end

            local now = GetGameTimer()
            if now >= nextToggle then
                local brakeOn = ((now // pulseInterval) % 2) == 0
                for w = 0, GetVehicleNumberOfWheels(veh) - 1 do
                    local target = brakeOn and 1.0 or 0.0
                    if w >= 2 then
                        target = brakeOn and rearPressureRatio or 0.0
                    end
                    SetVehicleWheelBrakePressure(veh, w, target)
                end
                nextToggle = now + pulseInterval
                debugPrint(("Brake %s"):format(brakeOn and "APPLY" or "RELEASE"))
            end
        else
            if isABSActive then
                isABSActive = false
                SetAllBrakePressure(veh, 1.0)
                SendNUIMessage({ type = "abs", status = false })
                debugPrint("<< ABS DISENGAGED")
            end
        end

        ::cont::
    end
end)
