local function createPlayer()
	local player = source
	Adame.GetLicense(player, function(license)
		TriggerClientEvent("adame:client:spawnPlayer", player)
	end)
end

RegisterNetEvent("adame:server:createPlayer", createPlayer)
