exports('get', function()
  local resourceName = GetInvokingResource()
  if not Adame.Resources[resourceName] then
    Adame.Resources[resourceName] = resourceName
  end
  return Adame
end)

exports('GetPlayer', function(playerId)
  return Adame.Players[playerId]
end)
