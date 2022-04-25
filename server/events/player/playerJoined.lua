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
