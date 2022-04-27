--- Remove commands in future
Adame.RegisterCommand('save', 'Save player', 'user', function(player, args)
  player:savePlayer()
end, {}, {})

--- User

Adame.RegisterCommand('id', 'Shows ID', 'user', function(player)
  print(player.source)
end)

--- Support commands

Adame.RegisterCommand('car', 'Spawn a vehicle', 'user', function(player, args)
  local vehicle = args.model
  local ped = GetPlayerPed(player.source)
  local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)

  if not ped or ped <= 0 then
    return
  end

  Adame.SpawnVehicle(vehicle, coords, heading, function(vehicle)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
  end)
end, { 'string-model' }, {
  { name = 'model', help = 'Vehicle name' },
})

Adame.RegisterCommand('dv', 'Delete vehicle', 'user', function(player, args)
  TriggerClientEvent('adame:client:deleteVehicle', player.source)
end, {}, {})

--- Moderator commands

--- Admin commands

--- Owner commands

Adame.RegisterCommand('setgroup', 'Set player group', 'user', function(player, args)
  player:setGroup(args.group)
end, { 'number-target', 'string-group' }, {
  { name = 'playerId', help = 'Player id' },
  { name = 'group', help = 'Group to set' },
})
