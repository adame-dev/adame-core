CreateThread(function()
	while true do
		for _, player in pairs(Adame.Players) do
			player:savePlayer()
		end
		Wait(Server.SaveTime)
	end
end)
