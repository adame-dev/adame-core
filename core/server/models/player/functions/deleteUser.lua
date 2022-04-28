Adame.DeleteUser = function(src)
	local player = src
	local license = Adame.GetLicense(player)

	if Adame.PlayerExist(license) then	
		Adame.Database.deleteOne(true, "users", { license = license })
		-- TODO: Create discord log when user remove
		if Adame.Players[player] then
			DropPlayer(player, '[adame-core] User removed. You can re-enter.')
			Adame.Players[player] = nil
		end
	else
		print("[adame-core] User doesn't exists.")
	end
end
