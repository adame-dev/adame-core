CreateThread(function()
	while true do
		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent("adame:server:createPlayer")
			break
		end
		Wait(0)
	end
end)
