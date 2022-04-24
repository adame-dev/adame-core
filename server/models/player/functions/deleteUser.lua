Adame.DeleteUser = function(src)
	local player = src
	local license = Adame.GetLicense(player)

	Adame.Database.deleteOne(true, "users", { license = license })
end
