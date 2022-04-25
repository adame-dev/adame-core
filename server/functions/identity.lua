Adame.setIdentity = function(source, license, data, callback)
	Adame.CreateCharacter(source, license, data)

	TriggerEvent("adame-identity:characterUpdated", source, data)
end

Adame.deleteIdentity = function(source, license)
	local data = {
		firstname = nil,
		lastname = nil,
		dateofbirth = nil,
		sex = nil,
		height = nil,
	}

	Adame.CreateCharacter(source, license, data)
end

RegisterServerEvent("adame-identity:setIdentity")
AddEventHandler("adame-identity:setIdentity", function(data)
	local player = Adame.Players[source]
	local license = Adame.GetLicense(player)
	local id = {
		license = Adame.GetLicense(playerId),
		playerid = playerId,
	}

	Adame.setIdentity(license, data)

	TriggerClientEvent("adame-identity:identityCheck", id.playerid, true)
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
