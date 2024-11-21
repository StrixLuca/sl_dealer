-- / ____||  ____||  __ \\ \    / /|  ____||  __ \  
-- | (___  | |__   | |__) |\ \  / / | |__   | |__) | 
--  \___ \ |  __|  |  _  /  \ \/ /  |  __|  |  _  /  
--  ____) || |____ | | \ \   \  /   | |____ | | \ \ 
-- |_____/ |______||_|  \_\   \/    |______||_|  \_\




lib.locale()
------------------
-----functions----
------------------
function registerBlackMarket()
    local shopItems = {}
    local server = require 'config.client'
    for _, item in ipairs(server.Config.BlackMarket.items) do
        if item.name and item.price then
            table.insert(shopItems, item.name)  
        else
            if server.Config.debug then
                lib.print.debug(locale('debug_no_item') .. ": " .. tostring(item))
            end
        end
    end
    
    exports.bl_bridge:inventory().registerInventory(server.Config.BlackMarket.id, {
        type = 'shop',
        name = server.Config.BlackMarket.name,
        items = server.Config.BlackMarket.items,
    })

    if server.Config.debug then
        lib.print.debug(locale('debug_register_check') .. ": " .. table.concat(shopItems, ", "))
    end
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        registerBlackMarket()
    end
end)

