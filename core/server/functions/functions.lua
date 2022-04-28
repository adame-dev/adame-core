local encode = json.encode
local decode = json.decode

Adame.GetLicense = function(playerId, cb)
  local identifiers = GetPlayerIdentifiers(playerId)
  local matchingIdentifier = 'license:'
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

local function format(value, style)
  if style == 'string' then
    return tostring(value)
  elseif style == 'number' then
    return tonumber(value)
  elseif style == 'boolean' then
    return value:lower() == 'true'
  else
    return value
  end
end

Adame.RegisterCommand = function(name, description, group, cb, types, suggestions)
  if type(name) == 'table' then
    for i = 1, #name do
      Adame.RegisterCommand(name[i], description, group, cb, types, suggestions)
    end
    return
  end

  if Adame.Commands[name] then
    error('Command ' .. name .. ' already exists.')
  end

  local invoke = GetInvokingResource()
  RegisterCommand(name, function(source, args)
    types = types or {}
    if #args < #types then
      print('Not enough arguments.')
      return
    end

    local player = Adame.Players[source]
    local arguments = {}
    for i = 1, #args do
      local style, argName = string.strsplit('-', types[i])
      local value = format(args[i], style)
      if args[i] ~= 'me' then
        if value == nil then
          print('Argument "' .. args[i] .. '" cannot be formatted into "' .. style .. '"')
          return
        end
        if argName == 'target' then
          player = Adame.Players[value]
          if not player then
            print('Player ' .. value .. ' not found.')
            return
          end
        end
      end
      arguments[argName] = value
    end

    if not player or not player:hasPermission(group) then
      print('No perms')
      return
    end
    if invoke == nil then
      cb(player, arguments)
    else
      cb(source, arguments)
    end
  end)

  -- Register new command on Adame.Commands
  Adame.Commands[name] = {
    description = description,
    group = group,
    suggestions = suggestions or {},
  }
end

---Refreshes the commands for the user with the specified group.
---@param playerId number - Id of the player (source)
---@return boolean - True if successful, false if not
Adame.RefreshCommands = function(playerId)
  local player = Adame.Players[playerId]
  if not player then
    return false
  end

  local suggestions = {}
  for name, command in pairs(Adame.Commands) do
    local commandName = '/' .. name
    if player:hasPermission(command.group) then
      suggestions[#suggestions + 1] = {
        name = commandName,
        help = command.description,
        params = command.suggestions,
      }
    else
      TriggerClientEvent('chat:removeSuggestion', player.source, commandName)
    end
  end
  TriggerClientEvent('chat:addSuggestions', player.source, suggestions)
  return true
end

Adame.SpawnVehicle = function(model, coords, heading, cb)
  local hash = GetHashKey(model)
  local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
  return cb(vehicle)
end

Adame.PlayerExist = function(license)
  local result = false

  Adame.Database.findOne(true, 'users', { license = license }, function(success, data)
    if not success then
      print('No user.')
      return
    end

    if #data > 0 then
      result = true
    end
  end)

  return result
end

Adame.PlayerData = function(license)
  local result

  Adame.Database.findOne(true, 'users', { license = license }, function(success, data)
    if not success then
      print('No user.')
      return
    end

    if #data > 0 then
      result = data[1]
    end
  end)

  return result
end