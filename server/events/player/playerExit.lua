function playerExit()
	local playerId = source
	local player = Adame.Players[playerId]
	if player then
		player:savePlayer()
		Adame.Players[playerId] = nil
		print("[Adame] Player " .. playerId .. " disconnected.")
	end
	DropPlayer(playerId, "[Adame] Left the server")
end

AddEventHandler("playerDropped", function()
	playerExit()
end)

RegisterNetEvent("adame:server:playerExit", playerExit)
