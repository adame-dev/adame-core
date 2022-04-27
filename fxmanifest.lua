fx_version('cerulean')
game('gta5')
use_fxv2_oal('yes')
lua54('yes')

name('adame-core')
author('Adame Developing')

server_scripts({
  'server/main.lua',
  'server/loops.lua',

  'server/models/player/player.lua',
  'server/models/player/functions/createUser.lua',
  'server/models/player/functions/deleteUser.lua',

  'server/functions/functions.lua',
  'server/functions/database/database.lua',
  'server/functions/callbacks.lua',

  'server/events/player.lua',

  'server/commands/commands.lua',

  'server/export.lua',

  'identity/server/main.lua',

  'config/server.lua',
})

client_scripts({
  'client/main.lua',
  'client/loops.lua',

  'client/identity/main.lua',
  'client/events/spawnPlayer.lua',
  'client/events/vehicle.lua',

  'client/functions/callbacks.lua',

  'client/export.lua',

  'identity/client/main.lua',

  'config/client.lua',
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
