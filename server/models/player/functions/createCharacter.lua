Adame.CreateCharacter = function(src, license, exists, data)
	if not exists then
		print("[Adame] User " .. license .. " not exist.")
	else
		Adame.Database.updateOne(true, "users", { license = license }, { ["$set"] = { char_name = data.char_name } })
	end
end
