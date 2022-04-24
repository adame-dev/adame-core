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
	if Adame.Commands[name] then
		error("Command " .. name .. " already exists.")
	end

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

	Adame.Commands[name] = {
		description = description,
		group = group,
		suggestions = suggestions or {},
	}
end

Adame.RefreshCommands = function(playerId)
	local player = Adame.Players[playerId]
	if not player then
		return false
	end

	local suggestions = {}
	for name, command in pairs(Adame.Commands) do
		local commandName = "/" .. name
		if player:hasPermission(command.group) then
			suggestions[#suggestions + 1] = {
				name = commandName,
				help = command.description,
				params = command.suggestions,
			}
		else
			TriggerClientEvent("chat:removeSuggestion", player.source, commandName)
		end
	end
	TriggerClientEvent("chat:addSuggestions", player.source, suggestions)
	return true
end

Adame.SpawnVehicle = function(model, coords, heading, cb)
	local hash = GetHashKey(model)
	local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
	return cb(vehicle)
end
