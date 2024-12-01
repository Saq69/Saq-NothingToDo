RegisterNetEvent('Saq:StartNothingToDo')
AddEventHandler('Saq:StartNothingToDo', function(time)
    StartNothingToDo(time)
end)

function StartNothingToDo(time)
    local isInRestrictedState = true
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if time == nil then time = Config["الوقت الافتراضي"] end

    local vehicles = {}
    local initialSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
    vehicles[vehicle] = initialSpeed

    Citizen.CreateThread(function()
        TriggerEvent('pogressBar:drawBar', time * 1000, '<font size=5 color=orange>قدراتك محدوده حتى انتهاء الوقت')
        Wait(time * 1000)
        isInRestrictedState = false
        for k, v in pairs(vehicles) do
            SetEntityMaxSpeed(k, v)
            table.remove(vehicles, k)
        end
    end)

    Citizen.CreateThread(function()
        while isInRestrictedState do
            Wait(5)

            SetEntityMaxSpeed(vehicle, Config["سرعة المركبة"])
            SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true) -- إزالة السلاح من اليد
            DisablePlayerFiring(playerPed, true) -- تعطيل إطلاق النار

            for control, _ in pairs(Config["الأزرار الممنوعة"]) do
                DisableControlAction(0, control, true)
            end
        end
    end)
end
