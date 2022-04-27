CreateThread(function()
  while true do
    for _, player in pairs(Adame.Players) do
      player:savePlayer()
      print('[adame-core] All players saved in database.')
    end
    Wait(Server.SaveTime)
  end
end)
