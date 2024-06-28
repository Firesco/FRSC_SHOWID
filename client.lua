local onlinePlayers, onlinePlayerss, forceDraw, firstspawn = {}, {}, false, true
local playerperm = {}
local admin = false

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    --if firstspawn then
        TriggerServerEvent('frsc-showid:admincheck')
        --firstSpawn = false
    --end
end)

RegisterNetEvent('frsc-showid:loadadmin')
AddEventHandler('frsc-showid:loadadmin', function(admins)
    if admins ~= nil or #admins > 0 then
        for k, v in pairs(admins) do
            for t, z in pairs(v) do
                playerperm[t] = z
                if z then
                    admin = true
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 50
        if Config.AlwaysOpen then
            sleep = 3
            forceDraw = true
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent("frsc-showid:add-id")
    while true do
        local sleep = 50
        if IsDisabledControlPressed(0, Config.Key) or forceDraw then
            sleep = 3
            for k, v in pairs(GetNeareastPlayers()) do
                local ped = GetPlayerPed(-1)
                local x, y, z = table.unpack(v.coords)
                if Config.AdminsOnly == true and admin == true then
                    Draw3DText(x, y, z + 1.05, v.playerId, Config.TextScale)
                    Draw3DText(x, y, z + 1.15, v.Text, Config.TextScale)
                    if Config.Marker then
                        DrawMarker(Config.MarkerType, x, y, z + 1.38, 0.0, 0.0, 0.0, 5.0, 0.0, 0.0, 0.2, 0.2, 0.15, Config.MarkerColor[1], Config.MarkerColor[2], Config.MarkerColor[3], 200, false, true, false, false, false, false, false)
                    end
                elseif Config.AdminsOnly == false then
                    Draw3DText(x, y, z + 1.05, v.playerId, Config.TextScale)
                    Draw3DText(x, y, z + 1.15, v.Text, Config.TextScale)
                    if Config.Marker then
                        DrawMarker(Config.MarkerType, x, y, z + 1.38, 0.0, 0.0, 0.0, 5.0, 0.0, 0.0, 0.2, 0.2, 0.15, Config.MarkerColor[1], Config.MarkerColor[2], Config.MarkerColor[3], 200, false, true, false, false, false, false, false)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('frsc-showid:client:add-id')
AddEventHandler('frsc-showid:client:add-id', function(identifier, playerSource)
    if playerSource then
        onlinePlayers[playerSource] = identifier
    else
        onlinePlayers = identifier
    end
end)

-- RegisterNetEvent('frsc-showid:client:add-id2')
-- AddEventHandler('frsc-showid:client:add-id2', function(identifier2, playerSource2)
--     if playerSource2 then
--         onlinePlayerss[playerSource2] = identifier2
--     else
--         onlinePlayerss = identifier2
--     end
-- end)

RegisterCommand(Config.CommandName, function()
    if forceDraw then
        forceDraw = false
    else
        forceDraw = true
        Citizen.Wait(Config.ForceDrawSecond)
        forceDraw = false
    end
end)

function Draw3DText(x, y, z, text, newScale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = newScale * (1 / dist) * (1 / GetGameplayCamFov()) * 100
        SetTextScale(scale, scale)
        SetTextFont(Config.TextFont)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end



function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players_clean = {}
    local playerCoords = GetEntityCoords(playerPed)

    local players, _ = GetPlayersInArea(playerCoords, Config.DrawDistance)
    for i = 1, #players, 1 do
        local playerServerId = GetPlayerServerId(players[i])
        local player = GetPlayerFromServerId(playerServerId)
        local ped = GetPlayerPed(player)
        local ping = playerPing
        if IsEntityVisible(ped) then
            local getstringstext = nil
            if Config.Type == "discord" then
                getstringstext = Config.Strings.discordtext
            elseif Config.Type == "steam" then
                getstringstext = Config.Strings.steamtext
            elseif Config.Type == "ip" then
                getstringstext = Config.Strings.iptext
            elseif Config.Type == "license" then
                getstringstext = Config.Strings.licensetext
            else
                getstringstext = Config.Strings.unknowntext
            end
            for x, identifier in pairs(onlinePlayers) do 
                if x == tostring(playerServerId) then
                    table.insert(players_clean, {Text = '~g~'..getstringstext:upper()..' : ~w~~b~'..identifier:upper()..'', playerId = '~g~'..Config.Strings.playertext..' : ~w~'..playerServerId..'', coords = GetEntityCoords(ped)})
                end
            end
        end
    end
   
    return players_clean
end


function GetPlayersInArea(coords, area)
	local players, playersInArea = GetPlayers(), {}
	local coords = vector3(coords.x, coords.y, coords.z)
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)

		if #(coords - targetCoords) <= area then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end