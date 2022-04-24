function playerJoined(playerId)
	local playerId = source or playerId
	if Adame.Players[playerId] then
		return DropPlayer(playerId, "[Adame] Player with same identifier is already logged in.")
	end

	local license = Adame.GetLicense(playerId)

	-- Start identity menu
end

RegisterNetEvent("adame:server:playerJoined", playerJoined)
