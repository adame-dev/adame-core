Adame.RegisterCommand("car", "Spawn a vehicle", "admin", function(source, args, playerData)
	local veh = args[1]
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
	Adame.SpawnVehicle(veh, coords, heading, function(veh)
		TaskWarpPedIntoVehicle(ped, veh, -1)
	end)
end, {}, false)
