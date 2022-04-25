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

Adame.RegisterCommand("register", "Spawn a vehicle", "user", function(source, args, playerData)
	local data

	Adame.Database.findOne(true, "users", { license = license }, function(success, result)
		if #result > 0 then
			print(result[1].char_name.firstname)
			if type(result[1].char_name) ~= "table" then
				data = {
					firstname = "",
					lastname = "",
					dateofbirth = "",
					sex = "",
					height = "",
				}
				TriggerClientEvent("adame-identity:showRegisterIdentity", source)
				print("asd")
			else
				data = {
					license = result[1].license,
					firstname = result[1].char_name.firstname,
					lastname = result[1].char_name.lastname,
					dateofbirth = result[1].char_date,
					sex = result[1].char_sex,
					height = result[1].char_height,
				}
				print("Already registered.")
			end
		else
			print("No user.")
		end
	end)
end, {}, false)

-- ESX.RegisterCommand("char", "user", function(xPlayer, args, showError)
-- 	getIdentity(xPlayer.source, function(data)
-- 		if data.firstname == "" then
-- 			xPlayer.showNotification(_U("not_registered"))
-- 		else
-- 			xPlayer.showNotification(_U("active_character", data.firstname, data.lastname))
-- 		end
-- 	end)
-- end, false, { help = _U("show_active_character") })

-- ESX.RegisterCommand("chardel", "user", function(xPlayer, args, showError)
-- 	getIdentity(xPlayer.source, function(data)
-- 		if data.firstname == "" then
-- 			xPlayer.showNotification(_U("not_registered"))
-- 		else
-- 			deleteIdentity(xPlayer.source)
-- 			xPlayer.showNotification(_U("deleted_character"))
-- 			TriggerClientEvent("esx_identity:showRegisterIdentity", xPlayer.source)
-- 		end
-- 	end)
-- end, false, { help = _U("delete_character") })
