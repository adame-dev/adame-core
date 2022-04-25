function setIdentity(source, license, data, callback)
	Adame.CreateCharacter(source, license, data)

	TriggerEvent("adame-identity:characterUpdated", source, data)
end

function deleteIdentity(source, license)
	local data2 = {
		firstname = "",
		lastname = "",
		dateofbirth = "",
		sex = "",
		height = "",
	}

	Adame.CreateCharacter(source, license, data2)
end

RegisterServerEvent("adame-identity:setIdentity")
AddEventHandler("adame-identity:setIdentity", function(data)
	local player = Adame.Players[source]
	local license = Adame.GetLicense(player)

	setIdentity(license, data)

	TriggerClientEvent("adame-identity:identityCheck", myIdentifiers.playerid, true)
	TriggerEvent("adame-identity:characterUpdated", player, data)
end)

AddEventHandler("adame-identity:characterUpdated", function(playerId, data)
	local player = Adame.Players[playerId]
	local char_data = {
		char_name = {
			firstname = data.firstname,
			lastname = data.lastname,
		},
		char_date = data.dateofbirth,
		char_sex = data.sex,
		char_height = data.height,
	}

	if player then
		player:updateCharacter(char_data)
	end
end)

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

function playerJoined(playerId)
	local playerId = source or playerId

	if Adame.Players[playerId] then
		return DropPlayer(playerId, "[Adame] Player with same identifier is already logged in.")
	end

	local license = Adame.GetLicense(playerId)

	local myID = {
		license = Adame.GetLicense(playerId),
		playerid = playerId,
	}

	TriggerClientEvent("adame-identity:saveID", playerId, myID)

	Adame.Database.findOne(true, "users", { license = license }, function(success, result)
		if #result > 0 then
			if type(result[1].char_name) ~= "table" then
				TriggerClientEvent("adame-identity:identityCheck", playerId, false)
				TriggerClientEvent("adame-identity:showRegisterIdentity", playerId)
			else
				TriggerClientEvent("adame-identity:identityCheck", playerId, true)
				TriggerEvent("adame-identity:characterUpdated", playerId, data)
				print("Already registered asdasd.")
			end
		else
			print("No user.")
		end
	end)
end

AddEventHandler("playerConnecting", function(_, _, deferrals)
	deferrals.defer()
	local playerId = source
	deferrals.update("[Adame] Checking player...")

	local license = Adame.GetLicense(playerId)
	Wait(500)
	if not license then
		deferrals.done("[Adame] No license found.")
		return CancelEvent()
	end
	deferrals.done()
end)

RegisterNetEvent("adame:server:playerJoined", playerJoined)
