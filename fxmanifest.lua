fx_version("adamant")
game("gta5")
description("FiveM Framework used for Adame projects.")
version("1.0.0")
server_scripts({
	"server/main.lua",

	"server/models/player.lua",

	"server/functions/functions.lua",
	"server/functions/events/createPlayer.lua",

	"config/server.lua",
})

client_scripts({
	"client/main.lua",

	"client/loops.lua",

	"client/events/spawnPlayer.lua",

	"config/client.lua",
})
