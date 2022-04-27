local encode = json.encode

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
      if result.char_date ~= '01-01-1900' then
        char_data = {
          firstname = result[1].char_name.firstname,
          lastname = result[1].char_name.lastname,
          dateofbirth = result[1].char_date,
          sex = result[1].char_sex,
          height = result[1].char_height,
        }
      else
        char_data = {
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

function setIdentity(identifier, data, callback)
  local player = Adame.GetPlayer(source)
  local license = Adame.GetLicense(source)

  Adame.Database.updateOne(true, 'users', { license = license }, {
    ['$set'] = {
      char_name = encode({ firstname = data.firstname, lastname = data.lastname }),
      char_date = data.dateofbirth,
      char_sex = data.sex,
      char_height = data.height,
    },
  })

  return true
end

function updateIdentity(playerId, data, callback)
  local player = Adame.GetPlayer(source)
  local license = Adame.GetLicense(source)

  Adame.Database.updateOne(true, 'users', { license = license }, {
    ['$set'] = {
      char_name = { firstname = data.firstname, lastname = data.lastname },
      char_date = data.dateofbirth,
      char_sex = data.sex,
      char_height = data.height,
    },
  })

  TriggerEvent('adame-identity:characterUpdated', playerId, data)
  return true
end

function deleteIdentity(source)
  local player = Adame.GetPlayer(source)
  local license = Adame.GetLicense(source)

  Adame.Database.updateOne(true, 'users', { license = license }, {
    ['$set'] = {
      char_name = { firstname = '', lastname = '' },
      char_date = '',
      char_sex = '',
      char_height = '',
    },
  })
end

RegisterServerEvent('adame-identity:setIdentity')
AddEventHandler('adame-identity:setIdentity', function(data, myIdentifiers)
  local player = Adame.GetPlayer(source)
  local license = Adame.GetLicense(source)

  setIdentity(myIdentifiers.steamid, data, function(callback)
    if callback then
      TriggerClientEvent('adame-identity:identityCheck', myIdentifiers.playerid, true)
      TriggerEvent('adame-identity:characterUpdated', myIdentifiers.playerid, data)
    else
      print('Failed identity.')
    end
  end)
end)

AddEventHandler('adame-identity:characterUpdated', function(playerId, data)
  local player = Adame.GetPlayer(playerId)

  if player then
    player.char_name = { firstname = data.firstname, lastname = data.lastname }
    player.char_date = data.dateofbirth
    player.char_sex = data.sex
    player.char_height = data.height
  end
end)

-- ESX.RegisterCommand("register", "user", function(xPlayer, args, showError)
-- 	getIdentity(xPlayer.source, function(data)
-- 		if data.firstname ~= "" then
-- 			xPlayer.showNotification(_U("already_registered"))
-- 		else
-- 			TriggerClientEvent("adame-identity:showRegisterIdentity", xPlayer.source)
-- 		end
-- 	end)
-- end, false, { help = _U("show_registration") })

-- ESX.RegisterCommand("char", "user", function(xPlayer, args, showError)
-- 	getIdentity(xPlayer.source, function(data)
-- 		if data.firstname == "" then
-- 			xPlayer.showNotification(_U("not_registered"))
-- 		else
-- 			xPlayer.showNotification(_U("active_character", data.firstname, data.lastname))
-- 		end
-- 	end)
-- end, false, { help = _U("show_active_character") })

-- ESX.RegisterCommand("chardel", "user", function(xPlayer, args, showError)
-- 	getIdentity(xPlayer.source, function(data)
-- 		if data.firstname == "" then
-- 			xPlayer.showNotification(_U("not_registered"))
-- 		else
-- 			deleteIdentity(xPlayer.source)
-- 			xPlayer.showNotification(_U("deleted_character"))
-- 			TriggerClientEvent("adame-identity:showRegisterIdentity", xPlayer.source)
-- 		end
-- 	end)
-- end, false, { help = _U("delete_character") })
