PW = nil

Citizen.CreateThread(function()
  while PW == nil do
      TriggerEvent('pw:loadFramework', function(obj) PW = obj end)
      Citizen.Wait(1)
  end
end)

if ss_enable_turn_signal_sync then

  local vehicleState = {
    indicator = {
      left = false,
      right = false
    }
  }
  
  RegisterNetEvent('pw_serversync:VehicleIndicator')
  AddEventHandler( "pw_serversync:VehicleIndicator", function( playerID, dir, state )
    SetVehicleIndicatorLights( GetVehiclePedIsIn( GetPlayerPed( GetPlayerFromServerId( playerID ) ), false ), dir, state )
  end)
  
  
  Citizen.CreateThread( function()
    while true do
      Citizen.Wait(10)
      if IsPedInAnyVehicle( GetPlayerPed( -1 ), false ) then
        local pressedLeft  = IsControlJustPressed( keybinds.indi.inputGroup, keybinds.indi.left ) or false
        local pressedRight = IsControlJustPressed( keybinds.indi.inputGroup, keybinds.indi.right ) or false
        if pressedLeft or pressedRight then
          local vehicle = GetVehiclePedIsIn( GetPlayerPed( -1 ), false )
          if GetPedInVehicleSeat( vehicle, - 1 ) == GetPlayerPed( -1 ) then
            if pressedLeft then
              vehicleState.indicator.left = not vehicleState.indicator.left
              TriggerServerEvent( "pw_serversync:SetVehicleIndicator", 1, vehicleState.indicator.left )
            end
            if pressedRight then
              vehicleState.indicator.right = not vehicleState.indicator.right
              TriggerServerEvent( "pw_serversync:SetVehicleIndicator", 0, vehicleState.indicator.right )
            end
          end
        end
      end
    end
  end)
  
end