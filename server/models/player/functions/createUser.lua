local encode = json.encode
local decode = json.decode

Adame.CreateUser = function(src, license, name, exists, data)
	if not exists then
		Adame.Database.insertOne(true, "users", {
			license = license,
			name = name,
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
			name,
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
			name,
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
