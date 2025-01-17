RegisterServerEvent('pw_core:server:startClientConnection')
AddEventHandler('pw_core:server:startClientConnection', function()
    local _src = source
    local _steam = PW.LoadSteamIdent(_src)

    if _steam then
        if PWBase['StartUp'].CreateUser(_steam, _src) then
            PWBase['StartUp'].LoadUser(_steam, _src)
        else
            DropPlayer(_src, "Failed to create a User Account on PixelWorld, please try reconnecting.")
        end
    else
        DropPlayer(_src, "Your Steam Identifier has not been located, please ensure Steam is open and restart FiveM")
    end
end)

AddEventHandler('playerDropped', function()
	local _src = source
	if(Users[_src])then
		TriggerEvent("pw:playerDropped", Users[_src])
        if Users[_src].saveUser(true) then
            Users[_src].unloadCharacter()
            Users[_src] = nil
        else
            Users[_src].unloadCharacter()
            Users[_src] = nil
        end
	end
end)

RegisterServerEvent('pw_core:server:characters:unloadIfLoaded')
AddEventHandler('pw_core:server:characters:unloadIfLoaded', function()
    local _src = source
    if Characters[_src] and Users[_src] then
        Users[_src].unloadCharacter()
    end
end)

exports('getUser', function(src)
    if Users[src] then
        return Users[src]
    end
    return false
end)

exports('getCharacter', function(src)
    if Characters[src] then
        return Characters[src]
    end
    return false
end)

RegisterServerEvent('pw_core:server:freeUpCharCreatorLocations')
AddEventHandler('pw_core:server:freeUpCharCreatorLocations', function()
    local _src = source
    for k, v in pairs(characterCreatorLocations) do
        if v.user == _src and v.inuse then
            v.user = 0
            v.inuse = false
        end
    end
end)

RegisterServerEvent('pw_core:server:loadCharacters')
AddEventHandler('pw_core:server:loadCharacters', function()
    local _src = source
    TriggerClientEvent('pw_core:nui:loadCharacters', _src, Users[_src].getCharacters())
end)

RegisterServerEvent('pw_core:server:verifyUserLogin')
AddEventHandler('pw_core:server:verifyUserLogin', function(data)
    local _src = source
    if data and Users[_src] then
        Users[_src].verifyLogin(data)
    end
end)

RegisterServerEvent('pw_core:server:deleteCharacter')
AddEventHandler('pw_core:server:deleteCharacter', function(data)
    local _src = source
    if data and Users[_src] then
        if Users[_src].deleteCharacter(tonumber(data.cid)) then
            TriggerClientEvent('pw_core:nui:showNotice', _src, "success", "Your character has been successfully deleted.", 5000)
            TriggerClientEvent('pw_core:nui:loadCharacters', _src, Users[_src].getCharacters())
        else
            TriggerClientEvent('pw_core:nui:showNotice', _src, "danger", "There was an error deleting your character, please try again.", 5000)
            TriggerClientEvent('pw_core:nui:loadCharacters', _src, Users[_src].getCharacters())
        end        
    else
        TriggerClientEvent('pw_core:nui:showNotice', _src, "danger", "There was an error deleting your character, please try again.", 5000)
        TriggerClientEvent('pw_core:nui:loadCharacters', _src, Users[_src].getCharacters())
    end
end)

RegisterServerEvent('getItemTest')
AddEventHandler('getItemTest', function()
    local _src = source
    if Characters[_src] then
        Characters[_src]:Inventory().Add().Slot(1, "bread", 1, {}, {}, 20, function(item)
            
        end, Characters[_src].getCID())
    end
end)

RegisterServerEvent('pw_core:server:spawnSelected')
AddEventHandler('pw_core:server:spawnSelected', function(data)
    local _src = source
    if data then
        if data.spawn.type == "property" then
            TriggerClientEvent('pw_properties:spawnedInHome', _src, tonumber(data.spawn.id))
        end
        TriggerClientEvent('pw_core:client:sendToWorld', _src, data.spawn)
    else
        TriggerClientEvent('pw_core:nui:loadCharacters', _src, Users[_src].getCharacters())
    end
end)