Adame.RegisterCommand("car", "Spawn a vehicle", "user", function(source, args, playerData)
	local veh = args[1]
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
	Adame.SpawnVehicle(veh, coords, heading, function(veh)
		TaskWarpPedIntoVehicle(ped, veh, -1)
	end)
end, {}, false)

Adame.RegisterCommand("setgroup", "Set player group", "owner", function(args)
	local id = tonumber(args[1])
	local group = args[2]
	if not id or not group then
		error("Missing an id to set the group (Use setgroup + id + group)")
	end
	local player = Adame.GetPlayer(id)
	player.setGroup(group)
end, {}, true)

Adame.RegisterCommand("dv", "Delete a vehicle", "user", function(source, args)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	TriggerClientEvent("adame:client:deleteVehicle", source)
end, {
	{ "number-distance" },
	{ name = "dist", help = "Distance to remove (default: 1.0)" },
}, false)
