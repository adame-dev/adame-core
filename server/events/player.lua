function getIdentity(source, callback)
  local player = Adame.GetPlayer(source)
  local license = Adame.GetLicense(source)
  local result
  local char_data

  Adame.Database.findOne(true, 'users', { license = license }, function(success, data)
    if not success then
      print('No user.')
      return
    end

    if #data > 0 then
      result = data[1]
      if result.char_name ~= '' then
        char_data = {
          identifier = result[1].license,
          firstname = result[1].char_name.firstname,
          lastname = result[1].char_name.lastname,
          dateofbirth = result[1].char_date,
          sex = result[1].char_sex,
          height = result[1].char_height,
        }
      else
        char_data = {
          identifier = '',
          firstname = '',
          lastname = '',
          dateofbirth = '',
          sex = '',
          height = '',
        }
      end
    end
  end)

  return char_data
end

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
  local player = Adame.Players[playerId]
  local license = Adame.GetLicense(playerId)
  local name = GetPlayerName(playerId)

  if player then
    return DropPlayer(playerId, '[adame-core] Player with same identifier is already logged in.')
  end

  print('[adame-core] Player ' .. name .. '[' .. playerId .. ']: ' .. license .. ' connected.')
  -- TODO: Create discord log when user connect

  createPlayer()

  -- Start identity menu
  local myID = {
    steamid = license,
    playerid = playerId,
  }

  TriggerClientEvent('adame-identity:saveID', playerId, myID)

  local data = getIdentity(playerId)

  print(data.firstname)
  if data.firstname ~= '' then
    TriggerClientEvent('adame-identity:identityCheck', playerId, true)
    TriggerEvent('adame-identity:characterUpdated', playerId, data)

    print('ab')
  else
    TriggerClientEvent('adame-identity:identityCheck', playerId, false)
    TriggerEvent('adame-identity:characterUpdated', playerId, data)
    TriggerClientEvent('adame-identity:showRegisterIdentity', playerId)
    print('ba')
  end
end

function playerExit()
  local playerId = source
  local player = Adame.Players[playerId]
  local license = Adame.GetLicense(playerId)
  local name = player:getName()

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

RegisterNetEvent('adame:server:createPlayer', createPlayer)
RegisterNetEvent('adame:server:playerJoined', playerJoined)
RegisterNetEvent('adame:server:playerExit', playerExit)
