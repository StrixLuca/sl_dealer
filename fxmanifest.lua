fx_version "adamant"
game "gta5"
author "Strixluca"
scriptname "sl_dealer"
lua54 "yes"
version 'v1.0.0'

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
    'config/dealerconfig.lua',
    'server/dealerconfig.lua', 
    'locales/*.json',
}

-- Shared scripts
shared_scripts {
    '@ox_lib/init.lua',
}