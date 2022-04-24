Adame.RegisterCommand("setgroup", "Set player group", "owner", function(args)
	local id = tonumber(args[1])
	local group = args[2]
	if not id or not group then
		error("Missing an id to set the group (Use setgroup + id + group)")
	end
	local player = Adame.GetPlayer(id)
	player.setGroup(group)
end, {}, true)
