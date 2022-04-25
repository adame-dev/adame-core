Adame.setIdentity = function(source, license, data, callback)
	Adame.CreateCharacter(source, license, data)

	TriggerEvent("adame-identity:characterUpdated", source, data)
end

Adame.deleteIdentity = function(source, license)
	local data2 = {
		firstname = nil,
		lastname = nil,
		dateofbirth = nil,
		sex = nil,
		height = nil,
	}

	Adame.CreateCharacter(source, license, data2)
end

RegisterServerEvent("adame-identity:setIdentity")
AddEventHandler("adame-identity:setIdentity", function(data)
	local player = Adame.Players[source]
	local license = Adame.GetLicense(player)

	Adame.setIdentity(license, data)

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
