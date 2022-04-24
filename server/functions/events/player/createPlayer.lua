local function playerExist(license)
	local result = false

	Adame.Database.findOne(true, "users", { license = license }, function(success, data)
		if not success then
			print("No user.")
			return
		end

		if #data > 0 then
			result = true
		end
	end)

	return result
end

local function playerData(license)
	local result

	Adame.Database.findOne(true, "users", { license = license }, function(success, data)
		if not success then
			print("No user.")
			return
		end

		if #data > 0 then
			result = data[1]
		end
	end)

	return result
end

local function createPlayer()
	local player = source
	Adame.GetLicense(player, function(license)
		if license then
			Adame.CreateUser(player, license, playerExist(license), playerData(license))
		else
			DropPlayer(player, "[Adame] License not found")
		end
	end)
end

RegisterNetEvent("adame:server:createPlayer", createPlayer)
