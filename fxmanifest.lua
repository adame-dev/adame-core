fx_version("cerulean")
game("gta5")
use_fxv2_oal("yes")
lua54("yes")

name("adame-core")
author("Adame Developing")

server_scripts({
	"server/main.lua",
	"server/loops.lua",
	"server/models/player.lua",

	"server/functions/functions.lua",

	"server/functions/events/player/createPlayer.lua",

	
	"server/functions/database/database.lua",

	"server/commands/car.lua",
	"server/commands/setgroup.lua",

	"config/server.lua",
})

client_scripts({
	"client/main.lua",
	"client/loops.lua",

	"client/events/spawnPlayer.lua",

	"config/client.lua",
})
