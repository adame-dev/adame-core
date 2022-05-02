Adame = {
	Commands = {},
	Methods = {},
	Resources = {},
	Players = {},
}

AddEventHandler("onResourceStart", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then
		return
	end
	print("[adame-core] Core started successfully.")
end)
