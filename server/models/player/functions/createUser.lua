local encode = json.encode
local decode = json.decode

--- Creates new user
--- @param src number - (player id)
--- @param license string - (player license)
--- @param name string - (player name)
--- @param exists boolean - (if player exists)
--- @param data table - (player data)
local function createUser(src, license, name, exists, data)
  if not exists then
    Adame.Database.insertOne(false, 'users', {
      license = license,
      name = name,
      accounts = encode(Server.Accounts),
      appearance = encode({}),
      group = Server.Groups[1] or 'user',
      status = encode(Server.Status),
      inventory = encode({}),
      identity = encode({}),
      job_data = encode({}),
      char_data = encode({ coords = Server.Spawn.coords }),
      char_name = encode({ firstname = 'Andrés', lastname = 'Velasco' }),
      char_sex = 'm',
      char_date = '01-01-1900',
      char_height = 170,
    })

    Adame.Players[src] = Adame.newPlayer(src, license, {
      name = name,
      jobs = {},
      group = Server.Groups[1] or 'user',
      accounts = Server.Accounts,
      inventory = {},
      status = Server.Status,
      appearance = {},
      char_data = { coords = Server.Spawn.coords },
      char_name = { firstname = 'Andrés', lastname = 'Velasco' },
      char_sex = 'm',
      char_date = '01-01-1900',
      char_height = 170,
    })
    print('[adame-core] Registered new user: ' .. name .. '[' .. src .. '] - ' .. license)

    TriggerClientEvent('adame-identity:identityCheck', src, false)
    TriggerClientEvent('adame-identity:showRegisterIdentity', src)
    TriggerEvent('adame:server:firstSpawn', src)

    -- TODO: Create discord log for register
  else
    Adame.Players[src] = Adame.newPlayer(src, license, {
      name = name,
      jobs = decode(data.job_data),
      group = data.group,
      accounts = decode(data.accounts),
      inventory = decode(data.inventory),
      status = decode(data.status),
      appearance = decode(data.appearance),
      char_data = decode(data.char_data),
      char_name = decode(data.char_name),
      char_sex = data.char_sex,
      char_date = data.char_date,
      char_height = data.char_height,
    })

    if data.date == '01-01-1900' then
      -- If char not exist
      TriggerClientEvent('adame-identity:identityCheck', src, false)
      TriggerClientEvent('adame-identity:showRegisterIdentity', src)
    else
      TriggerClientEvent('adame-identity:identityCheck', src, true)
      TriggerEvent('adame-identity:characterUpdated', src, data)
    end
    print('[adame-core] Loaded user: ' .. name .. '[' .. src .. '] - ' .. license)
  end
end

RegisterNetEvent('adame:server:createUser', createUser)
