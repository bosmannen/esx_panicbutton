local ESX = nil

-- Initialize ESX
Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(100)
    end
end)

-- Handle the alert event from the client
RegisterServerEvent('noodknop:alertPolice')
AddEventHandler('noodknop:alertPolice', function(coords)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Notify all police officers of the alert
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local player = ESX.GetPlayerFromId(playerId)

        if player.job.name == 'police' then
            TriggerClientEvent('noodknop:playSoundForPolice', playerId) -- Trigger the sound
            TriggerClientEvent('noodknop:notifyPolice', playerId, "Er heeft een agent op zijn noodknop gedrukt") -- Notify all officers
            TriggerClientEvent('noodknop:setWaypoint', playerId, coords) -- Set waypoint for all police officers
        end
    end
end)
