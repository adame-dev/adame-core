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
      DropPlayer(player, '[Adame] License not found')
    end
  end)
end

function playerJoined(playerId)
  local playerId = source or playerId
  local player = Adame.Players[playerId]
  local license = Adame.GetLicense(playerId)
  local name = player:getName()

  if player then
    return DropPlayer(playerId, '[Adame] Player with same identifier is already logged in.')
  end

  print('[Adame] Player ' .. name .. '[' .. playerId .. ']: ' .. license .. ' connected.')
  -- Start identity menu
end

AddEventHandler('playerConnecting', function(_, _, deferrals)
  deferrals.defer()
  local playerId = source
  deferrals.update('[Adame] Checking player...')

  local license = Adame.GetLicense(playerId)
  Wait(500)
  if not license then
    deferrals.done('[Adame] No license found.')
    return CancelEvent()
  end
  deferrals.done()
end)

function playerExit()
  local playerId = source
  local player = Adame.Players[playerId]
  local license = Adame.GetLicense(playerId)
  local name = player:getName()

  if player then
    player:savePlayer()
    Adame.Players[playerId] = nil
    print('[Adame] Player ' .. name .. '[' .. playerId .. ']: ' .. license .. ' disconnected.')
  end
  DropPlayer(playerId, '[Adame] Left the server')
end

AddEventHandler('playerDropped', function()
  playerExit()
end)

RegisterNetEvent('adame:server:createPlayer', createPlayer)
RegisterNetEvent('adame:server:playerJoined', playerJoined)
RegisterNetEvent('adame:server:playerExit', playerExit)
