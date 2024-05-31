onlinePlayers = {}
onlinePlayerss = {}

RegisterServerEvent('frsc-showid:add-id')
AddEventHandler('frsc-showid:add-id', function()
    TriggerClientEvent("frsc-showid:client:add-id", source, onlinePlayers)
    TriggerClientEvent("frsc-showid:client:add-id", source, onlinePlayerss)
    local Text = ".."
    local identifiers = GetPlayerIdentifiers(source)
    local name = GetPlayerName(source)
    if string.lower(Config.Type) == 'discord' then
        for k, v in ipairs(identifiers) do
            if string.match(v, 'discord:') then
                Text = string.sub(v, 9)
                break
            end
        end
    elseif string.lower(Config.Type) == 'steam' then
        for k, v in ipairs(identifiers) do
            if string.match(v, 'steam:') then
                Text = string.sub(v, 7)
                break
            end
        end
    elseif string.lower(Config.Type) == 'license' then
        for k, v in ipairs(identifiers) do
            if string.match(v, 'license:') then
                Text = string.sub(v, 9)
                break
            end
        end
    elseif string.lower(Config.Type) == 'ip' then
        for k, v in ipairs(identifiers) do
            if string.match(v, 'ip:') then
                Text = string.sub(v, 4)
                break
            end
        end
    elseif string.lower(Config.Type) == 'live' then
        for k, v in ipairs(identifiers) do
            if string.match(v, 'live:') then
                Text = string.sub(v, 1)
                break
            end
        end
    elseif string.lower(Config.Type) == 'xbl' then
        for k, v in ipairs(identifiers) do
            if string.match(v, 'xbl:') then
                Text = string.sub(v, 1)
                break
            end
        end    
    end    
    onlinePlayers[tostring(source)] = Text
    onlinePlayerss[tostring(source)] = Text
    TriggerClientEvent("frsc-showid:client:add-id", -1, Text, tostring(source))
end)

AddEventHandler('playerDropped', function(reason)
    onlinePlayers[tostring(source)] = nil
    onlinePlayerss[tostring(source)] = nil
end)

local perm = {'admin'}

RegisterServerEvent('frsc-showid:admincheck')
AddEventHandler('frsc-showid:admincheck', function()
	local src = source
    local perms = {}

    for k, v in pairs(perm) do
        if IsPlayerAceAllowed(src, 'showid.'..v) then
            table.insert(perms, {[v] = true})
        else
            table.insert(perms, {[v] = false})
        end
    end

    TriggerClientEvent('frsc-showid:loadadmin', src, perms)
end)

