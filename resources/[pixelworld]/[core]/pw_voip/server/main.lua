RegisterServerEvent("pw_voip:server:InitialiseMumble")
AddEventHandler("pw_voip:server:InitialiseMumble", function()
    DebugMsg("Initialised player: " .. source)

    if not voiceData[source] then
        voiceData[source] = {
            mode = 2,
            radio = 0,
            radioActive = false,
            call = 0,
            callSpeaker = false,
        }
    end

    TriggerClientEvent("pw_voip:SyncMumbleVoiceData", -1, voiceData, radioData, callData)
end)

RegisterServerEvent("pw_voip:server:SetMumbleVoiceData")
AddEventHandler("pw_voip:server:SetMumbleVoiceData", function(key, value)
    if not voiceData[source] then
        voiceData[source] = {
            mode = 2,
            radio = 0,
            radioActive = false,
            call = 0,
            callSpeaker = false,
        }
    end

    local radioChannel = voiceData[source]["radio"]
    local callChannel = voiceData[source]["call"]
    local radioActive = voiceData[source]["radioActive"]

    if key == "radio" and radioChannel ~= value then -- Check if channel has changed
        if radioChannel > 0 then -- Check if player was in a radio channel
            if radioData[radioChannel] then  -- Remove player from radio channel
                if radioData[radioChannel][source] then
                    DebugMsg("Player " .. source .. " was removed from radio channel " .. radioChannel)
                    radioData[radioChannel][source] = nil
                end
            end
        end

        if value > 0 then
            if not radioData[value] then -- Create channel if it does not exist
                DebugMsg("Player " .. source .. " is creating channel: " .. value)
                radioData[value] = {}
            end
            
            DebugMsg("Player " .. source .. " was added to channel: " .. value)
            radioData[value][source] = true -- Add player to channel
        end
    elseif key == "call" and callChannel ~= value then
        if callChannel > 0 then -- Check if player was in a call channel
            if callData[callChannel] then  -- Remove player from call channel
                if callData[callChannel][source] then
                    DebugMsg("Player " .. source .. " was removed from call channel " .. callChannel)
                    callData[callChannel][source] = nil
                end
            end
        end

        if value > 0 then
            if not callData[value] then -- Create call if it does not exist
                DebugMsg("Player " .. source .. " is creating call: " .. value)
                callData[value] = {}
            end
            
            DebugMsg("Player " .. source .. " was added to call: " .. value)
            callData[value][source] = true -- Add player to call
        end
    end

    voiceData[source][key] = value

    DebugMsg("Player " .. source .. " changed " .. key .. " to: " .. tostring(value))

    TriggerClientEvent("pw_voip:client:SetMumbleVoiceData", -1, source, key, value)
end)

exports.pw_chat:AddAdminChatCommand('radiochannels', function(source, args, rawCommand)
    if source > 0 then
        for id, players in pairs(radioData) do
            for player, _ in pairs(players) do
                local _char = exports['pw_core']:getCharacter(player)
                local _charName = _char.getFullName()
                print("Radio Channels: " .. id .. "-> id: " .. player .. ", RP NAME: " .. _charName .. "NAME: " .. GetPlayerName(player) .. "\n")
            end
        end
    end
    
end, {
    help = 'Check Radio Channels in Use'
}, -1)

exports.pw_chat:AddAdminChatCommand('callchannels', function(source, args, rawCommand)
    if source > 0 then
        for id, players in pairs(callData) do
            for player, _ in pairs(players) do
                local _char = exports['pw_core']:getCharacter(player)
                local _charName = _char.getFullName()
                print("Call Channel IDs: " .. id .. "-> id: " .. player .. ", RP NAME: " .. _charName .. "NAME: " .. GetPlayerName(player) .. "\n")
            end
        end
    end
    
end, {
    help = 'Check Call Channels in Use'
}, -1)

AddEventHandler("playerDropped", function()
    if voiceData[source] then
        local radioChanged = false
        local callChanged = false

        if voiceData[source].radio > 0 then
            if radioData[voiceData[source].radio] ~= nil then
                radioData[voiceData[source].radio][source] = nil
                radioChanged = true
            end
        end

        if voiceData[source].call > 0 then
            if callData[voiceData[source].call] ~= nil then
                callData[voiceData[source].call][source] = nil
                callChanged = true
            end
        end

        voiceData[source] = nil
        
        TriggerClientEvent("pw_voip:RemoveMumbleVoiceData", -1, source)
    end
end)