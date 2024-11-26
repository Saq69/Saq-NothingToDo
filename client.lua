RegisterNetEvent('Saq:StartNothingToDo')
AddEventHandler('Saq:StartNothingToDo', function()
    StartNothingToDo()
end)

function StartNothingToDo()
    local isInRestrictedState = true
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    local vehicles = {}

    local initialSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")

    vehicles[vehicle] = initialSpeed

    Citizen.CreateThread(function()
        TriggerEvent('pogressBar:drawBar', 30000, '<font size=5 color=orange>قدراتك محدوده حتى انتهاء الوقت')
        Wait(30000) 
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
            DisableControlAction(0, 21) -- Disable sprinting
            DisableControlAction(0, 22) -- Disable jumping
            DisableControlAction(0, 37) -- Disable weapon menu
            DisableControlAction(0, 45) -- Disable reloading
            DisableControlAction(0, 24) -- Disable punching
            DisableControlAction(0, 69) -- Disable melee attack
            DisableControlAction(0, 92) -- Disable melee attack (alternate)
            DisablePlayerFiring(playerPed, true) -- Disable shooting
            DisableControlAction(0, 106, true) -- Disable hitting with weapons
            DisableControlAction(0, 140, true) -- Disable reloading and melee attacks
            DisableControlAction(0, 141, true) -- Disable stabbing with knife
        end

    end)
end
