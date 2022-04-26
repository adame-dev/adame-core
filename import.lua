Adame = exports['adame-core']:get()

Adame.GetPlayer = function(playerId)
  local copyPlayer = exports['adame-core']:GetPlayer(playerId)
  if not copyPlayer then
    return false
  end
  return setmetatable(copyPlayer, {
    __index = function(self, name)
      if not Adame.Methods[name] then
        error('[Adame] Method ' .. name .. '() does not exist')
      end
      return function(...)
        if type(self[name]) == 'function' then
          return exports['adame-core']['adame_' .. name](nil, self.source, ...)
        end
      end
    end,
  })
end
