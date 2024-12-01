local disabledControls = {
    [21] = true, -- Sprinting
    [22] = true, -- Jumping
    [37] = true, -- Weapon wheel
    [45] = true, -- Reloading
    [24] = true, -- Punching
    [69] = true, -- Melee attack (primary)
    [92] = true, -- Melee attack (secondary)
    [106] = true, -- Hitting with weapon
    [140] = true, -- Reloading and melee attacks
    [141] = true  -- Stabbing with knife
}

RegisterNetEvent('Saq:StartNothingToDo')
AddEventHandler('Saq:StartNothingToDo', function(time)
    StartNothingToDo(time)
end)

function StartNothingToDo(time)
    local isInRestrictedState = true
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if time == nil then time = 30 end

    local vehicles = {}

    local initialSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")

    vehicles[vehicle] = initialSpeed


    Citizen.CreateThread(function()
        TriggerEvent('pogressBar:drawBar', time*1000, '<font size=5 color=orange>قدراتك محدوده حتى انتهاء الوقت')
        Wait(time*1000) 
        isInRestrictedState = false 
        for k, v in pairs(vehicles) do
            SetEntityMaxSpeed(k, v)
            table.remove(vehicles, k) 
        end
    end)

    Citizen.CreateThread(function()
        while isInRestrictedState do
            Wait(5) 

            SetEntityMaxSpeed(vehicle, 9.0)
            SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true) -- Remove weapon from hand
            DisablePlayerFiring(playerPed, true) -- Disable shooting

            for control, _ in pairs(disabledControls) do
                DisableControlAction(0, control, true)
            end
        end
    end)
end
