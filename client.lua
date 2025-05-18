local PlayerData = {}
ESX = exports["es_extended"]:getSharedObject()
Citizen.CreateThread(function()


    while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end

    PlayerData = ESX.GetPlayerData()
    Citizen.Wait(1)
end)


-- Handle playerLoaded event
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayers
end)

-- Handle setJob event
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('Saq:StartNothingToDo')
AddEventHandler('Saq:StartNothingToDo', function(time)
    StartNothingToDo(time)
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
    StartNothingToDo(30)
end)

function StartNothingToDo(time)
    local isInRestrictedState = true
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if time == nil then time = Config["الوقت الافتراضي"] end
    if Config["الوظائف"][PlayerData.job.name] == nil then

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
end
