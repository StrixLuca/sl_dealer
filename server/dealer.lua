-- / ____||  ____||  __ \\ \    / /|  ____||  __ \  
-- | (___  | |__   | |__) |\ \  / / | |__   | |__) | 
--  \___ \ |  __|  |  _  /  \ \/ /  |  __|  |  _  /  
--  ____) || |____ | | \ \   \  /   | |____ | | \ \ 
-- |_____/ |______||_|  \_\   \/    |______||_|  \_\



------------------
----ALL LOCALS----
------------------
lib.locale()
local inventory = exports.bl_bridge:inventory()
local sharedConfig = require 'config.dealerconfig'

------------------
-----functions----
------------------
function registerBlackMarket()
    local shopItems = {}

    -- Gebruik de correcte structuur: sharedConfig.Config.BlackMarket
    for _, item in ipairs(sharedConfig.Config.BlackMarket.items) do
        if item.name and item.price then
            table.insert(shopItems, item.name)  
        else
            if sharedConfig.Config.debug then
                lib.print.debug(locale('debug_no_item') .. ": " .. tostring(item))
            end
        end
    end

    -- Registreer het Black Market inventory
    inventory.registerInventory(sharedConfig.Config.BlackMarket.id, {
        type = 'shop',
        name = sharedConfig.Config.BlackMarket.name,
        items = sharedConfig.Config.BlackMarket.items,
    })

    -- Debug output als het is ingeschakeld
    if sharedConfig.Config.debug then
        lib.print.debug(locale('debug_register_check') .. ": " .. table.concat(shopItems, ", "))
    end
end

-- Event handler bij het starten van de resource
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        registerBlackMarket()
    end
end)
