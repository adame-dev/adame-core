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
	"server/models/player/functions/deleteUser.lua",
	"server/models/player/functions/createCharacter.lua",

	"server/functions/functions.lua",
	"server/functions/database/database.lua",

	"server/events/player/createPlayer.lua",
	"server/events/player/playerExit.lua",
	"server/events/player/playerJoined.lua",

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
