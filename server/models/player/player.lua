local player = {}
setmetatable(Adame.Players, player)

local encode = json.encode

player.__index = player

--- Creates player metadata

--- @param playerId number - (player id)
--- @param identifier string - (player license)
--- @param data table - (player data)
--- @return table

Adame.newPlayer = function(playerId, identifier, data)
  local self = {}
  self.source = playerId
  self.identifier = identifier
  self.name = data.name
  self.jobs = data.jobs
  self.group = data.group
  self.accounts = data.accounts
  self.inventory = data.inventory
  self.status = data.status
  self.appearance = data.appearance
  self.char_data = data.char_data
  self.char_name = data.char_name
  self.char_sex = data.char_sex
  self.char_date = data.char_date
  self.char_height = data.char_height

  -- Load
  SetEntityCoords(GetPlayerPed(playerId), self.char_data.coords.x, self.char_data.coords.y, self.char_data.coords.z)
  SetEntityHeading(GetPlayerPed(playerId), self.char_data.coords.w)

  return setmetatable(self, getmetatable(Adame.Players))
end

--- Save data to database

function player:savePlayer()
  local ped = GetPlayerPed(self.source)

  local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
  self:updateCoords(vector4(coords, heading))

  Adame.Database.updateOne(true, 'users', { license = self.identifier }, {
    ['$set'] = {
      accounts = encode(self.accounts),
      appearance = encode(self.appearance),
      status = encode(self.status),
      inventory = encode(self.inventory),
      job_data = encode(self.jobs),
      char_data = encode(self.char_data),
    },
  })
end

--- #Getters

--- Return the player name
--- @return string - (player realname)
function player:getName()
  return self.name
end

--- Return the character name
--- @return table - (character name)
function player:getCharacterName()
  return {
    firstname = self.char_name.firstname,
    lastname = self.char_name.lastname,
  }
end

--- Return if player has permission
--- @param group string - (group name)
--- @return boolean - (true if has permission)
function player:hasPermission(group)
  if not Server.Groups[group] then
    return false
  end

  return Server.Groups[self.group] >= Server.Groups[group]
end

--- #Setters

--- Set the player group
--- @param group string - (group name)
--- @return boolean - (true if set)
function player:setGroup(group)
  if not Server.Groups[group] then
    return false
  end

  self.group = group
  Adame.RefreshCommands(self.source)
  return true
end

--- Update character information
--- @param char_data table - (character data)
--- @return boolean - (true if set)
function player:updateCharacter(char_data)
  if not char_data then
    return false
  end

  self.char_name = char_data.char_name
  self.char_sex = char_data.char_sex
  self.char_date = char_data.char_date
  self.char_height = char_data.char_height
  return true
end

function player:updateCoords(coords, now)
  if type(coords) ~= 'vector4' then
    return false
  end
  if now then
    local ped = GetPlayerPed(self.source)
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
    SetEntityHeading(ped, coords.w)
  end

  self.char_data.coords = vec4(coords)
  return true
end

---Exportable methods

local count = 0
for name, func in pairs(player) do
  if type(func) == 'function' then
    exports('adame_' .. name, function(playerId, ...)
      local player = Adame.Players[playerId]
      return player[name](player, ...)
    end)
    Adame.Methods[name] = name
    count = count + 1
  end
end

print('[adame-core] Loaded ' .. count .. ' exportable methods')
