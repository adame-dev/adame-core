local encode = json.encode
local decode = json.decode

Adame.CreateUser = function(src, license, name, exists, data)
	if not exists then
		-- Si no existe
		Adame.Database.insertOne(false, "users", {
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
			char_name = encode({}),
			char_sex = "m",
			char_date = "01/01/1999",
			char_height = 170,
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
			Server.Spawn.coords,
			{},
			"m",
			"01/01/1999",
			170
		)
	else
		-- Si existe
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
			decode(data.char_data),
			decode(data.char_name),
			data.char_sex,
			data.char_date,
			data.char_height
		)
		TriggerClientEvent("adame:client:spawnPlayer", src, decode(data.char_data).coords)
	end
end
