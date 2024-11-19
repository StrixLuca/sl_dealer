----------------------
-- Alle Lokale Variabelen --
----------------------

lib.locale()
local config = require 'config.dealerconfig'
local serverConfig = require 'server.dealerconfig'
local framework = exports.bl_bridge
local core = framework:core()
local target = framework:target()
local inventory = framework:inventory()
local progressbar = framework:progressbar()
local notify = framework:notify()

local npcInteract = nil
local huidigeLocatie = nil

if not core and config.Config.debug then
    lib.print.debug(locale('debugNoCore'))
    return
end

----------------------
-- Lokale Functies --
----------------------

-- Kies een willekeurige locatie die verschilt van de vorige
local function randomLocatie()
    local nieuweIndex
    repeat
        nieuweIndex = lib.math.random(1, #serverConfig.locations)
    until nieuweIndex ~= huidigeLocatie
    huidigeLocatie = nieuweIndex
end

-- Toon een melding als een item aanwezig is
local function toonmelding()
    if config.Config.usenotification then
        local vereistItem = config.Config.item
        if inventory.hasItem(vereistItem) then
            notify({
                description = config.Config.BlackMarket.dealername .. " " .. locale('dealerLocationChange'),
                type = 'success',
                duration = config.Config.notifyduration
            })
        end
    end
end

-- Logica voor NPC interactie
local function npcinteractie()
    progressbar.showProgress({
        duration = config.Config.progressbar.duration,
        label = locale('progressBarLabel'),
        canCancel = true,
        disableControl = { move = true, car = true, mouse = true, combat = true },
        animation = { dict = config.Config.progressbar.dict, clip = config.Config.progressbar.clip },
    })

    if config.Config.interaction == 'target' or config.Config.interaction == 'interact' then
        TaskPlayAnim(npcInteract, config.Config.npcanimation.dict, config.Config.npcanimation.clip, 8.0, -8.0, -1, 1, 0, false, false, false)
        Wait(config.Config.progressbar.duration)
    end

    inventory.openInventory("shop", config.Config.BlackMarket.id)

    if config.Config.interaction == 'target' or config.Config.interaction == 'interact' then
        ClearPedTasks(npcInteract)
    end

    if config.Config.debug then
        lib.print.debug(locale('debugNpcDeal'))
    end
end

-- Configureer interactieopties voor de NPC
local function configureernpcinteractie(npc, opties)
    if config.Config.interaction == 'target' then
        target.addEntity({ entity = npc, options = opties })
    elseif config.Config.interaction == 'interact' then
    elseif GetResourceState('interaction-menu') == 'started' then
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
            }
    elseif GetResourceState('interact') == 'started' then
            exports.interact:AddEntityInteraction({
                netId = NetworkGetNetworkIdFromEntity(npc),
                id = 'dealer_interaction',
                distance = 5.0,
                interactDst = 3.0,
                options = opties
            })
        elseif GetResourceState('sleepless_interact') == 'started' then
            exports.sleepless_interact:addEntity({
                id = "interactnpc",
                netId = NetworkGetNetworkIdFromEntity(npc),
                options = opties,
                renderDistance = 5.0,
                activeDistance = 3.0,
            })
        else
            lib.print.warn(locale('noInteractionEnabled'))
        end
end

-- Maak een NPC punt
local function maaknpcPunt(coords)
    local point = lib.points.new({
        coords = coords,
        distance = config.Config.npcLoadDistance,
    })

    function point:onEnter()
        spawnNpc()
    end

    function point:onExit()
        if npcInteract then
            DeleteEntity(npcInteract)
            npcInteract = nil
        end
    end
end

-- Spawn een NPC op de huidige locatie
function spawnNpc()
    if npcInteract then return end

    local locatie = serverConfig.locations[huidigeLocatie]
    local coords = locatie.coords
    local model = config.Config.BlackMarket.model

    if lib.requestModel(model, 10000) then
        npcInteract = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, true, false)
        SetBlockingOfNonTemporaryEvents(npcInteract, true)
        SetEntityInvincible(npcInteract, true)
        FreezeEntityPosition(npcInteract, true)

        local opties = {
            { label = locale('target'), icon = config.Config.interacticon, onSelect = npcinteractie }
        }

        configureernpcinteractie(npcInteract, opties)
        SetModelAsNoLongerNeeded(model)

        maaknpcPunt(coords)

        if config.Config.debug then
          lib.print.debug(locale('debugNpcSpawn'))
        end
    elseif config.Config.debug then
        lib.print.debug(locale('debug_model_loading_failed') .. ": " .. model)
    end
end

-- Start de NPC locatie cyclus
local function startLocatieCyclus()
    randomLocatie()
    spawnNpc()

    SetTimeout(config.Config.npcspawntime * 60 * 1000, function()
        randomLocatie()

        if npcInteract then
            DeleteEntity(npcInteract)
            npcInteract = nil
        end

        spawnNpc()
        toonmelding()
    end)
end

----------------------
-- Initialisatie --
----------------------

startLocatieCyclus()