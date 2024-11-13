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


------------------
-----functions----
------------------

function registerBlackMarket()
    local shopItems = {}

    for _, item in ipairs(Config.BlackMarket.items) do
        if item.name and item.price then
            table.insert(shopItems, item.name)  
        else
            if Config.debug then
                lib.print.debug(locale('debug_no_item') .. ": " .. tostring(item))
            end
        end
    end

    inventory.registerInventory(Config.BlackMarket.id, {
        type = 'shop',  
        name = Config.BlackMarket.name,
        items = Config.BlackMarket.items,  
    })

    if Config.debug then
        lib.print.debug(locale('debug_register_check') .. ": " .. table.concat(shopItems, ", ")) 
    end
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        registerBlackMarket()
    end
end)