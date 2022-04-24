local encode = json.encode
local decode = json.decode

Adame.GetLicense = function(playerId, cb)
	local identifiers = GetPlayerIdentifiers(playerId)
	local matchingIdentifier = "license:"
	for i = 1, #identifiers do
		if identifiers[i]:match(matchingIdentifier) then
			if not cb then
				return identifiers[i]
			end
			return cb(identifiers[i])
		end
	end
	if not cb then
		return false
	end
	return cb(false)
end

Adame.CreateUser = function(src, license, exists, data)
	if not exists then
		Adame.Database.insertOne(true, "users", {
			license = license,
			accounts = encode(Server.Accounts),
			appearance = encode({}),
			group = Server.Groups[1] or "user",
			status = encode(Server.Status),
			inventory = encode({}),
			identity = encode({}),
			job_data = encode({}),
			char_data = encode({ coords = Server.Spawn.coords }),
		})

		print("[Adame] Created user: " .. license)

		Adame.Players[src] = Adame.SetData(
			src,
			license,
			{},
			Server.Groups[1] or "user",
			Server.Accounts,
			{},
			Server.Status,
			{},
			Server.Spawn.coords
		)
	else
		Adame.Players[src] = Adame.SetData(
			src,
			license,
			decode(data.job_data),
			data.group,
			decode(data.accounts),
			decode(data.inventory),
			decode(data.status),
			decode(data.appearance),
			decode(data.char_data)
		)
		TriggerClientEvent("adame:client:spawnPlayer", src, decode(data.char_data).coords)
	end
end

Adame.SetGroup = function(id, group)
	if not Adame.Players[tonumber(id)] then
		return
	end
	Adame.Players[tonumber(id)].group = group
end

Adame.GetPlayer = function(id)
	local data = {}
	data.src = id
	data.group = Adame.Players[id].group

	data.setGroup = function(group)
		Adame.SetGroup(data.src, group)
	end

	return data
end

Adame.RegisterCommand = function(name, description, group, cb, suggestions, rcon)
	RegisterCommand(name, function(source, args, rawCommand)
		local src = source
		if rcon then
			if src == 0 then
				cb(args)
			end
		else
			local player = Adame.GetPlayer(src)
			if player.group == group then
				cb(src, args, player)
			end
		end
	end)
end

Adame.SpawnVehicle = function(model, coords, heading, cb)
	local hash = GetHashKey(model)
	local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
	return cb(vehicle)
end
