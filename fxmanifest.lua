fx_version "adamant"
game "gta5"
author "Strixluca"
scriptname "sl_dealer"
lua54 "yes"
version '1.0.0'

-- Library dependencies
ox_lib 'locale'

-- Client scripts
client_scripts {
    'client/*.lua',
    '@bl_bridge/imports/client.lua',
}

-- Server scripts
server_scripts {
    'server/*.lua',
    '@bl_bridge/imports/server.lua',
}

-- Files to include
files {
    'config/client.lua',
    'config/server.lua', 
    'locales/*.json',
}

-- Shared scripts
shared_scripts {
    '@ox_lib/init.lua',
}

dependency {'ox_lib' ,'bl_bridge'}