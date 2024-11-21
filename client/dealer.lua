----------------------
-- Alle Lokale Variabelen --
----------------------
lib.locale()
local npcinteract = nil
local huidigeLocatie = nil
----------------------
-- Lokale Functies --
----------------------
local function randomLocatie()
    local serverConfig = require 'config.server'
    local nieuweIndex
    repeat
        nieuweIndex = lib.math.random(1, #serverConfig.locations)
    until nieuweIndex ~= huidigeLocatie
    huidigeLocatie = nieuweIndex
end


local function toonmelding()
    local config = require 'config.client'
    if config.Config.usenotification then
        local vereistItem = config.Config.item
        if exports.bl_bridge:inventory().hasItem(vereistItem) then
            exports.bl_bridge:notify()({
                description = config.Config.BlackMarket.dealername .. " " .. locale('dealerLocationChange'),
                type = 'success',
                duration = config.Config.notifyduration
            })
        end
    end
end


local function npcinteractie()
    local config = require 'config.client'
    if cache.vehicle then return
        exports.bl_bridge:notify()({
            description = locale('zitinauto'),
            type = 'error',
            duration = config.Config.notifyduration
        })
    
     end
     exports.bl_bridge:progressbar().showProgress({
        duration = config.Config.progressbar.duration,
        label = locale('progressBarLabel'),
        canCancel = true,
        disableControl = { move = true, car = true, mouse = true, combat = true },
        animation = { dict = config.Config.progressbar.dict, clip = config.Config.progressbar.clip },
    })

    if config.Config.interaction == 'target' or config.Config.interaction == 'interact' then
        TaskPlayAnim(npcinteract, config.Config.npcanimation.dict, config.Config.npcanimation.clip, 8.0, -8.0, -1, 1, 0, false, false, false)
        Wait(config.Config.progressbar.duration)
    end

    exports.bl_bridge:inventory().openInventory("shop", config.Config.BlackMarket.id)

    if config.Config.interaction == 'target' or config.Config.interaction == 'interact' then
        ClearPedTasks(npcinteract)
    end

    if config.Config.debug then
        lib.print.debug(locale('debugNpcDeal'))
    end
end


local function configureernpcinteractie(npc, opties) 
    local config = require 'config.client'
    if config.Config.interaction == 'target' then
        exports.bl_bridge:target().addEntity({ entity = npc, options = opties })
    end  
    if config.Config.interaction == 'interact' then
        if GetResourceState('interactionMenu') == 'started' then
           exports['interactionMenu']:Create {
            entity = NetworkGetNetworkIdFromEntity(npc),
            offset = vec3(0, 0, 0),
            maxDistance = 3.0,
            options = {
                {
                    label = locale('target'),
                    icon = config.Config.interacticon,
                    action = function()
                            npcinteractie()
                        end
                    }
                }
            } end
            if GetResourceState('interact') == 'started' then
            exports.interact:AddEntityInteraction({
                netId = NetworkGetNetworkIdFromEntity(npc),
                id = 'dealer_interaction',
                distance = 5.0,
                interactDst = 3.0,
                options = opties
            }) end
            if GetResourceState('sleepless_interact') == 'started' then
            exports.sleepless_interact:addEntity({
                id = "interactnpc",
                netId = NetworkGetNetworkIdFromEntity(npc),
                options = opties,
                renderDistance = 5.0,
                activeDistance = 3.0,
            }) end
        else
            lib.print.warn(locale('noInteractionEnabled'))
        end
end


local function maaknpcpunt(coords)
    local config = require 'config.client'
    local point = lib.points.new({
        coords = coords,
        distance = config.Config.npcLoadDistance,
    })

    function point:onEnter()
        npcspawn()
    end

    function point:onExit()
        if npcinteract then
            DeleteEntity(npcinteract)
            npcinteract = nil
        end
    end
end


function npcspawn()
    local config = require 'config.client'
     local serverConfig = require 'config.server'
    if npcinteract then return end

    local locatie = serverConfig.locations[huidigeLocatie]
    local coords = locatie.coords
    local model = config.Config.BlackMarket.model

    if lib.requestModel(model, 10000) then
        npcinteract = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, true, false)
        SetBlockingOfNonTemporaryEvents(npcinteract, true)
        SetEntityInvincible(npcinteract, true)
        FreezeEntityPosition(npcinteract, true)

        local opties = {
            { label = locale('target'), icon = config.Config.interacticon, onSelect = npcinteractie }
        }

        configureernpcinteractie(npcinteract, opties)
        SetModelAsNoLongerNeeded(model)

        maaknpcpunt(coords)

        if config.Config.debug then
          lib.print.debug(locale('debugNpcSpawn'))
        end
    elseif config.Config.debug then
        lib.print.debug(locale('debug_model_loading_failed') .. ": " .. model)
    end
end


local function startLocatieCyclus()
    local config = require 'config.client'
    randomLocatie()
    npcspawn()

    SetTimeout(config.Config.npcspawntime * 60 * 1000, function()
        randomLocatie()

        if npcinteract then
            DeleteEntity(npcinteract)
            npcinteract = nil
        end

        npcspawn()
        toonmelding()
    end)
end

----------------------
-- Initialisatie --
----------------------

startLocatieCyclus()
