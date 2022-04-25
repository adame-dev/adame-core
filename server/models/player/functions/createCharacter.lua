Adame.CreateCharacter = function(src, license, data)
	if not exists then
		print("[Adame] User " .. license .. " not exist.")
	else
		Adame.Database.updateOne(true, "users", { license = license }, {
			["$set"] = {
				char_name = { firstname = data.firstname, lastname = data.lastname },
				char_date = data.dateofbirth,
				char_sex = data.sex,
				char_height = data.height,
			},
		})
	end
end
