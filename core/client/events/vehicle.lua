local distanceToCheck = 5.0

local numRetries = 5

RegisterNetEvent('adame:client:deleteVehicle')
AddEventHandler('adame:client:deleteVehicle', function()
  local ped = PlayerPedId()

  if DoesEntityExist(ped) and not IsEntityDead(ped) then
    local pos = GetEntityCoords(ped)

    if IsPedSittingInAnyVehicle(ped) then
      local vehicle = GetVehiclePedIsIn(ped, false)

      if GetPedInVehicleSeat(vehicle, -1) == ped then
        DeleteGivenVehicle(vehicle, numRetries)
      else
        -- Notify "You must be in the driver's seat!"
      end
    else
      local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(ped, 0.0, distanceToCheck, 0.0)
      local vehicle = GetVehicleInDirection(ped, pos, inFrontOfPlayer)

      if DoesEntityExist(vehicle) then
        DeleteGivenVehicle(vehicle, numRetries)
      else
        -- Notify "~y~You must be in or near a vehicle to delete it."
      end
    end
  end
end)

function DeleteGivenVehicle(veh, timeoutMax)
  local timeout = 0

  SetEntityAsMissionEntity(veh, true, true)
  DeleteVehicle(veh)

  if DoesEntityExist(veh) then
    -- Notify "~r~Failed to delete vehicle, trying again..."

    -- Fallback if the vehicle doesn't get deleted
    while DoesEntityExist(veh) and timeout < timeoutMax do
      DeleteVehicle(veh)

      -- The vehicle has been banished from the face of the Earth!
      if not DoesEntityExist(veh) then
        -- Notify "~g~Vehicle deleted."
      end

      -- Increase the timeout counter and make the system wait
      timeout = timeout + 1
      Citizen.Wait(500)

      -- We've timed out and the vehicle still hasn't been deleted.
      if DoesEntityExist(veh) and (timeout == timeoutMax - 1) then
        --Notify "~r~Failed to delete vehicle after " .. timeoutMax .. " retries."
      end
    end
  else
    -- Notify "~g~Vehicle deleted."
  end
end

function GetVehicleInDirection(entFrom, coordFrom, coordTo)
  local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7)
  local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

  if IsEntityAVehicle(vehicle) then
    return vehicle
  end
end
