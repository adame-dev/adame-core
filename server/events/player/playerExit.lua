function playerExit()
	local playerId = source
	local player = Adame.Players[playerId]
	if player then
		player:savePlayer()
		Adame.Players[playerId] = nil
	end
	DropPlayer(playerId, "[Adame] Left the server")
end

AddEventHandler("playerDropped", function()
	playerExit()
end)

RegisterNetEvent("adame:server:playerExit", playerExit)
