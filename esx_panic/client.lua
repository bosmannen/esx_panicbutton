local ESX = nil
local canNotify = true -- Flag to control notification spam
local canPlaySound = true -- Flag to control sound spam
local notificationCooldown = 5000 -- Cooldown duration for notifications (5 seconds)
local soundCooldown = 5000 -- Cooldown duration for sound (5 seconds)

-- Initialize ESX
Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(100)
    end
    print("ESX Loaded on Client") -- Debug print
end)

-- Function to alert all police officers
local function alertPoliceOfficers()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Trigger server event to alert police officers
    TriggerServerEvent('noodknop:alertPolice', playerCoords)
end

-- Key binding to listen for F9 key presses
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Prevent the thread from blocking

        if IsControlJustPressed(1, 344) then -- 344 is F9
            local xPlayer = ESX.GetPlayerData()

            -- Check if the player is a police officer
            if xPlayer.job and xPlayer.job.name == 'police' then
                -- Check if the player has a radio
                local hasRadio = false
                for _, item in ipairs(xPlayer.inventory) do
                    if item.name == 'radio' and item.count > 0 then
                        hasRadio = true
                        break
                    end
                end

                if hasRadio then
                    alertPoliceOfficers() -- Call function to alert officers
                else
                    exports['ox_lib']:notify({
                        title = "Radio",
                        description = 'Je hebt een "radio" noding om de noodknop te gebruiken',
                        type = "error",
                        position = "top",
                    })
                end
            else
                print("Not a police officer, job: " .. (xPlayer.job and xPlayer.job.name or "unknown")) -- Debug print
            end
        end
    end
end)

-- Client event to play the sound for police officers
RegisterNetEvent('noodknop:playSoundForPolice')
AddEventHandler('noodknop:playSoundForPolice', function()
    if canPlaySound then
        print("Playing sound for police officers") -- Debug print
        SendNUIMessage({ action = "playSound" }) -- Play sound for all police
        canPlaySound = false -- Disable further sound plays

        -- Set timeout to allow sound play again
        Citizen.SetTimeout(soundCooldown, function()
            canPlaySound = true -- Re-enable sound after the cooldown
        end)
    end
end)

-- Client event to receive notification
RegisterNetEvent('noodknop:notifyPolice')
AddEventHandler('noodknop:notifyPolice', function(message)
    if canNotify then
        print("Received notification: " .. message) -- Debug print
        exports['ox_lib']:notify({
            title = "Noodknop!",
            description = message,
            type = "warning",
            position = "top",
            style = { backgroundColor = '#962929', color = '#FFFFFF' }
        })

        canNotify = false -- Disable further notifications

        -- Set timeout to allow notifications again
        Citizen.SetTimeout(notificationCooldown, function()
            canNotify = true -- Re-enable notifications after the cooldown
        end)
    end
end)

-- Client event to set waypoint for police officers
RegisterNetEvent('noodknop:setWaypoint')
AddEventHandler('noodknop:setWaypoint', function(coords)
    print("Setting waypoint for police officers") -- Debug print
    SetNewWaypoint(coords.x, coords.y) -- Set a waypoint at the coordinates
end)
