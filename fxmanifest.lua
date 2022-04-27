fx_version('cerulean')
game('gta5')
use_fxv2_oal('yes')
lua54('yes')

name('adame-core')
author('Adame Developing')

server_scripts({
  'core/server/main.lua',
  'core/server/loops.lua',

  'core/server/models/player/player.lua',
  'core/server/models/player/functions/createUser.lua',
  'core/server/models/player/functions/deleteUser.lua',

  'core/server/functions/functions.lua',
  'core/server/functions/database/database.lua',
  'core/server/functions/callbacks.lua',

  'core/server/events/player.lua',

  'core/server/commands/commands.lua',

  'core/server/export.lua',

  'identity/server/main.lua',

  'core/config/client.lua',
  'core/config/server.lua',
})

client_scripts({
  'core/client/main.lua',
  'core/client/loops.lua',

  'core/client/identity/main.lua',
  'core/client/events/spawnPlayer.lua',
  'core/client/events/vehicle.lua',

  'core/client/small/anims/handsup.lua',
  'core/client/small/weapons/weapdrop.lua',
  'core/client/small/density.lua',
  'core/client/small/discord.lua',
  'core/client/small/removeentities.lua',

  'core/client/functions/callbacks.lua',

  'core/client/export.lua',

  'identity/client/main.lua',

  'core/config/client.lua',
  'core/config/server.lua',
})

files({
  -- Import file
  'import.lua',
  'identity/web/index.html',
  'identity/web/script.js',
  'identity/web/style.css',
})

ui_page('identity/web/index.html')

dependencies({
  '/onesync',
})

provide('core')
