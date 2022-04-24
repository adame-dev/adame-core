fx_version("cerulean")
game("gta5")
use_fxv2_oal("yes")
lua54("yes")

name("adame-core")
author("Adame Developing")

server_scripts({
	"server/main.lua",
	"server/loops.lua",

	"server/models/player/player.lua",
	"server/models/player/functions/createUser.lua",

	"server/functions/functions.lua",
	"server/functions/player/createUser.lua",

	"server/events/player/createPlayer.lua",

	"server/functions/database/database.lua",

	"server/commands/commands.lua",

	"config/server.lua",
})

client_scripts({
	"client/main.lua",
	"client/loops.lua",

	"client/events/spawnPlayer.lua",
	"client/events/vehicle.lua",

	"config/client.lua",
})

provide("core")
