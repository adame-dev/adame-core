local function setParams()
  local ped = PlayerPedId()
  SetCanAttackFriendly(ped, true, false)
  SetMaxWantedLevel(0)
  SetPedDefaultComponentVariation(ped)
end

local function spawnPlayer(coords)
  exports['spawnmanager']:spawnPlayer({
    model = 'mp_m_freemode_01',
    heading = coords.w,
    x = coords.x,
    y = coords.y,
    z = coords.z,
  }, function()
    setParams()
  end)
end
RegisterNetEvent('adame:client:spawnPlayer', spawnPlayer)
