-- _____  _       _____  ______  _   _  _______ 
-- / ____|| |     |_   _||  ____|| \ | ||__   __|
-- | |     | |       | |  | |__   |  \| |   | |   
-- | |     | |       | |  |  __|  | . ` |   | |   
-- | |____ | |____  _| |_ | |____ | |\  |   | |   
-- \_____||______||_____||______||_| \_|   |_|   

------------------
----ALL LOCALS----
------------------
lib.locale()
local core = exports.bl_bridge:core()
local target = exports.bl_bridge:target()
local npcEntity = nil
local inventory = exports.bl_bridge:inventory()
local nieuwelocatie = nil  
local oudelocatie = nil  

if not core and Config.debug then
    lib.print.debug(locale('debug_no_core'))
    return
end

------------------
-----functions----
------------------

local function randomlocaties()
    local nieuweindex
    repeat
        nieuweindex = lib.math.random(1, #Config.BlackMarket.locations)  
    until nieuweindex ~= oudelocatie  
    oudelocatie = nieuweindex  
    nieuwelocatie = nieuweindex  
end

local function telefoonmelding(location)
    local data = {
        content = location.notification.content,
        attachments = location.notification.attachments,
        replyTo = nil,
        hashtags = location.notification.hashtags,
        ---name = location.notification.name  soon
    }

    local jaja = exports["lb-phone"]:PostBirdy(data)

    if Config.debug then
        lib.print.debug(locale('debug_phone_debug') .. ": " .. tostring(jaja))
    end
end

local function addNPCInteraction(npcEntity, options)

    if Config.target and not Config.interact then 
        target.addEntity({
            entity = npcEntity,
            options = options  
        })
    elseif Config.interact and not Config.target then
        exports.sleepless_interact:addEntity({
            id = "interactnpc",
            netId = NetworkGetNetworkIdFromEntity(npcEntity),  
            options = options,
            renderDistance = 5.0,
            activeDistance = 3.0,
        })
    elseif Config.interact and Config.target then
        lib.print.warn(locale('debug_targetconfig'))
    end
end

local function spawnNPC()
    if npcEntity then
        DeleteEntity(npcEntity)  
    end

    local location = Config.BlackMarket.locations[nieuwelocatie]
    local coords = location.coords  
    local model = Config.BlackMarket.model  

    local options = {
        {
            label = locale('target'),
            icon = "fa-solid fa-handshake",
            onSelect = function()
                inventory.openInventory("shop", Config.BlackMarket.id)  
                if Config.debug then
                    lib.print.warn(locale('debug_npc_deal'))
                end
            end
        }
    }

    if lib.requestModel(model, 10000) then
        npcEntity = CreatePed(4, model, coords.x, coords.y, coords.z, 0.0, true, false)  
        SetBlockingOfNonTemporaryEvents(npcEntity, true)
        SetPedDiesWhenInjured(npcEntity, false)
        SetPedCanPlayAmbientAnims(npcEntity, true)
        SetPedCanRagdollFromPlayerImpact(npcEntity, false)
        SetEntityInvincible(npcEntity, true)
        FreezeEntityPosition(npcEntity, true)

        if Config.target or Config.interact then 
            addNPCInteraction(npcEntity, options)  -- Roep de functie aan
        end

        SetModelAsNoLongerNeeded(model)

        if Config.debug then
            lib.print.debug(locale('debug_npc_spawn') .. ": " .. tostring(coords))
        end
        if Config.lbphone then
        telefoonmelding(location)  
        end
    else
        if Config.debug then
            lib.print.debug(locale('debug_model_loading') .. ": " .. model) 
        end
    end
end

local function locatieveranderen()
    randomlocaties()  
    spawnNPC()  
end

local function startTimer()
    randomlocaties()  
    spawnNPC()  
    SetTimeout(Config.BlackMarket.spawnInterval * 60 * 1000, function()  
        locatieveranderen() 
        startTimer()  
    end)
end

startTimer()  