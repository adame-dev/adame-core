local encode = json.encode

RegisterServerEvent("adame-identity:setIdentity")
AddEventHandler("adame-identity:setIdentity", function(data)
	local license = Adame.GetLicense(source)
	local player = Adame.Players[source]

	Adame.Database.updateOne(true, "users", { license = license }, {
		["$set"] = {
			char_name = encode({ firstname = data.firstname, lastname = data.lastname }),
			char_date = data.dateofbirth,
			char_sex = data.sex,
			char_height = data.height,
		},
	})

	TriggerClientEvent("adame-identity:identityCheck", source, true)
end)
