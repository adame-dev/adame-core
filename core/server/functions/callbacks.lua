Adame.RegisterServerCallback = function(name, cb)
    if type(name) ~= 'string' then error('Adame: RegisterServerCallback: name must be a string') end
    Adame.Callbacks[name] = cb
  end

  RegisterServerEvent('adame:server:cb_trigger', function(name, ...)
    local playerId <const> = source
    local rValue = nil
  
    if Adame.Callbacks[name] then
      rValue = Adame.Callbacks[name](playerId, ...)
    else
      rValue = nil
      print('Adame: ServerCallback ' .. name .. ' not found')
    end
  
    TriggerClientEvent('adame:client:cb_handler', playerId, name, rValue)
  end)