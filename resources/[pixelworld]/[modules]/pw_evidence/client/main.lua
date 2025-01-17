PW = nil
getEvidence, characterLoaded, GLOBAL_PED, GLOBAL_COORDS, playerData = true, false, nil, nil, nil
local evidence = nil
local closestEvidence = nil

Citizen.CreateThread(function()
    while PW == nil do
        TriggerEvent('pw:loadFramework', function(framework) PW = framework end)
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('pw:characterLoaded')
AddEventHandler('pw:characterLoaded', function(unload, ready, data)
    if not unload then
        if ready then
            GLOBAL_PED = PlayerPedId()
            GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
            characterLoaded = true
        else
            playerData = data
        end
    else
        playerData = nil
        characterLoaded = false
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(500)
        if characterLoaded then
            local playerPed = PlayerPedId()
            if playerPed ~= GLOBAL_PED then
                GLOBAL_PED = playerPed
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        if characterLoaded then
            GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
        end
    end
end)

function DrawText3Ds(x,y,z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

RegisterNetEvent('pw:updateJob')
AddEventHandler('pw:updateJob', function(data)
    if characterLoaded and playerData then
        playerData.job = data
    end    
end)

RegisterNetEvent('pw:toggleDuty')
AddEventHandler('pw:toggleDuty', function(toggle)
    if characterLoaded and playerData then
        playerData.job.duty = toggle
    end
end)

RegisterNetEvent('pw_evidence:client:removeLocalEvidence')
AddEventHandler('pw_evidence:client:removeLocalEvidence', function(ident)
    if evidence ~= nil then
        for k, v in pairs(evidence) do
            if v.evidenceIdent == ident then
                evidence[k] = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if characterLoaded and GLOBAL_PED and playerData then
            if playerData.job.name == "police" and playerData.job.duty and GetSelectedPedWeapon(GLOBAL_PED) == -1951375401 then
                local minScan = 70
                local closestID = false
                local drawMsg
                if IsPlayerFreeAiming(PlayerId()) then                   
                    if getEvidence then
                        getEvidence = false
                        PW.TriggerServerCallback('pw_evidence:server:requestEvidenceZone', function(data)
                            evidence = data
                        end, GetZoneAtCoords(GLOBAL_COORDS.x, GLOBAL_COORDS.y, GLOBAL_COORDS.z))
                    end

                    if evidence ~= nil and evidence[1] ~= nil then
                        for k, v in pairs(evidence) do
                            local distance = #(GLOBAL_COORDS - vector3(v.hitCoords.x, v.hitCoords.y, v.hitCoords.z))
                            if distance < 20 then
                                if distance < minScan then
                                    minScan = distance
                                    closestID = k
                                end
                                if distance < 4.5 then
                                    if v.evidenceType == "projectile" then
                                        DrawMarker(0, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 56, 165, 61, 250, false, false, 2, false, false, false, false)
                                        drawMsg = "Bullet Fragment"
                                    elseif v.evidenceType == "vehiclefragment" then
                                        if v.hitEntity.class == 8 or v.hitEntity.class == 9 then -- motorbikes
                                            drawMsg = "Motorcycle Fragment\nPlate: "..v.meta.plate
                                            DrawMarker(37, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, v.hitEntity.r, v.hitEntity.g, v.hitEntity.b, 250, false, false, 2, false, false, false, false)
                                        elseif v.hitEntity.class == 10 or v.hitEntity.class == 11 or v.hitEntity.class == 12 then -- trucks
                                            drawMsg = "Vehicle Fragment\nPlate: "..v.meta.plate
                                            DrawMarker(39, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, v.hitEntity.r, v.hitEntity.g, v.hitEntity.b, 250, false, false, 2, false, false, false, false)
                                        elseif v.hitEntity.class == 13 then -- bycyucles
                                            drawMsg = "Bycycle Fragment"
                                            DrawMarker(38, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, v.hitEntity.r, v.hitEntity.g, v.hitEntity.b, 250, false, false, 2, false, false, false, false)
                                        elseif v.hitEntity.class == 16 then -- planes
                                            drawMsg = "Vehicle Fragment"
                                            DrawMarker(33, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, v.hitEntity.r, v.hitEntity.g, v.hitEntity.b, 250, false, false, 2, false, false, false, false)
                                        elseif v.hitEntity.class == 15 then -- helis
                                            drawMsg = "Vehicle Fragment"
                                            DrawMarker(34, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, v.hitEntity.r, v.hitEntity.g, v.hitEntity.b, 250, false, false, 2, false, false, false, false)
                                        elseif v.hitEntity.class == 14 then -- boats
                                            drawMsg = "Vehicle Fragment"
                                            DrawMarker(35, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, v.hitEntity.r, v.hitEntity.g, v.hitEntity.b, 250, false, false, 2, false, false, false, false)
                                        else
                                            drawMsg = "Vehicle Fragment\nPlate: "..v.meta.plate
                                            DrawMarker(36, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, v.hitEntity.r, v.hitEntity.g, v.hitEntity.b, 250, false, false, 2, false, false, false, false)
                                        end
                                    elseif v.evidenceType == "dna" then
                                        drawMsg = "DNA-"..v.meta.player.cid
                                        DrawMarker(28, v.hitCoords.x, v.hitCoords.y, v.hitCoords.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 255, 0, 0, 250, false, false, 2, false, false, false, false)
                                    end
                                end
                            end
                        end
                    end

                    if closestID then
                        DrawText3Ds(evidence[closestID].hitCoords.x, evidence[closestID].hitCoords.y, evidence[closestID].hitCoords.z+0.23, drawMsg)
                        if IsControlJustReleased(0,38) and minScan < 2.0 then
                            print('picked up shit')
                            TriggerServerEvent('pw_evidence:server:evidencePickedUp', evidence[closestID].evidenceIdent, GLOBAL_COORDS)
                        end
                    end
                else
                    evidence = nil
                    getEvidence = true
                end
            else
                evidence = nil
                getEvidence = true
            end
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent('pw_evidence:client:requestCoordstoClear')
AddEventHandler('pw_evidence:client:requestCoordstoClear', function()
    if GLOBAL_COORDS then
        TriggerServerEvent('pw_evidence:server:clearArea', GLOBAL_COORDS, 50)
    end
end)