local callbacks = {}

Adame.TriggerServerCallback = function(name, cb, ...)
  if type(name) ~= 'string' then
    error('Adame: TriggerServerCallback: name must be a string')
  end
  if callbacks[name] then
    print('Adame: ServerCallback ' .. name .. ' already using, wait to resolve it')
    return nil
  end
  callbacks[name] = cb
  TriggerServerEvent('adame:server:cb_trigger', name, ...)
end

RegisterNetEvent('adame:client:cb_handler', function(name, ...)
  callbacks[name](...)
  callbacks[name] = nil
end)
