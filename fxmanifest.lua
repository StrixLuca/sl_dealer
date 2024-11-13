fx_version "adamant"
author "Strixluca"
game "gta5"
scriptname "sl_dealer"
lua54 "yes"
version 'v1.0.0'

ox_lib 'locale'

client_scripts {
    'client/*.lua',
    '@bl_bridge/imports/client.lua',
}
 
server_scripts {
    'server/*.lua',
    '@bl_bridge/imports/server.lua',
}

files {
    'locales/*.json'
  }
  
shared_scripts { 
	'shared/*.lua',
    '@ox_lib/init.lua',
}
