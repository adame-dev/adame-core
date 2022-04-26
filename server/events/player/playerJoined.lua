function playerJoined(playerId)
	local playerId = source or playerId
	if Adame.Players[playerId] then
		return DropPlayer(playerId, "[Adame] Player with same identifier is already logged in.")
	end

	local license = Adame.GetLicense(playerId)

	-- Start identity menu
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
