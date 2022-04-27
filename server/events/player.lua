local function playerExist(license)
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

local function playerData(license)
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

local function createPlayer()
  local player = source
  local name = GetPlayerName(player)

  Adame.GetLicense(player, function(license)
    if license then
      TriggerEvent('adame:server:createUser', player, license, name, playerExist(license), playerData(license))
    else
      DropPlayer(player, '[adame-core] License not found')
    end
  end)
end

function playerJoined(playerId)
  local playerId = source or playerId
  local license = Adame.GetLicense(playerId)
  local name = GetPlayerName(playerId)

  if Adame.Players[playerId] then
    return DropPlayer(playerId, '[adame-core] Player with same identifier is already logged in.')
  end

  print('[adame-core] Player ' .. name .. '[' .. playerId .. ']: ' .. license .. ' connected.')

  createPlayer()

  -- TODO: Create discord log when user connect
end

function playerExit()
  local playerId = source
  local player = Adame.Players[playerId]
  local license = Adame.GetLicense(playerId)
  local name = GetPlayerName(playerId)

  if player then
    player:savePlayer()
    Adame.Players[playerId] = nil
    print('[adame-core] Player ' .. name .. '[' .. playerId .. ']: ' .. license .. ' disconnected.')
    -- TODO: Create discord log when user disconnect
  end
  DropPlayer(playerId, '[Adame] Left the server')
end

AddEventHandler('playerConnecting', function(_, _, deferrals)
  deferrals.defer()
  local playerId = source
  deferrals.update('[adame-core] Checking player...')

  local license = Adame.GetLicense(playerId)
  Wait(500)
  if not license then
    deferrals.done('[adame-core] No license found.')
    return CancelEvent()
  end
  deferrals.done()
end)

AddEventHandler('playerDropped', function()
  playerExit()
end)


function firstSpawn()
  local playerId <const> = source
  local license = Adame.GetLicense(playerId)

  SetEntityCoords(GetPlayerPed(playerId), Server.Spawn.coords.x, Server.Spawn.coords.y, Server.Spawn.coords.z)
  SetEntityHeading(GetPlayerPed(playerId), Server.Spawn.coords.w)
end

RegisterNetEvent('adame:server:createPlayer', createPlayer)
RegisterNetEvent('adame:server:playerJoined', playerJoined)
RegisterNetEvent('adame:server:firstSpawn', playerExit)
