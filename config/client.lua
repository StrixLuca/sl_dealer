-- _____  ____   _   _  ______  _____  _____ 
-- / ____|/ __ \ | \ | ||  ____||_   _|/ ____|
-- | |    | |  | ||  \| || |__     | | | |  __ 
-- | |    | |  | || .  ||  __|    | | | | |_ |
-- | |____| |__| || |\  || |      _| |_| |__| |
-- \_____|\____/ |_| \_||_|     |_____|\_____|

return {
    Config = {
        ---Devs
        debug = true,           -- Enable debug mode (true/false) for devs
        -----------------------------------------------------------------------------------------
        -- Interaction settings only one on true!
        interaction = 'target',                 --  (target) for QB/OX  (interact) for sleepless/interact/interaction-menu
        interacticon = 'phone',                 -- change the icon for interact
        npcLoadDistance = 50,                   -- NPC Load in for player distance (fps proof)
        -----------------------------------------------------------------------------------------

        --- Notification for dealer change
        usenotification = true,                -- True for notification if dealer switch location
        item = 'locakpick',                        -- Change the item for the notification
        notifyduration = 2500,                 -- Duration for the notify
        -----------------------------------------------------------------------------------------

        --- SpawnTime settings
        npcspawntime = 60,                     -- Interval for NPC location change (in minutes)
        ------------------------------------------------------------------------------------------
     
        --- Progress bar settings and animation
        progressbar = {
            dict = "mp_common",               -- Animation dictionary for progress bar
            clip = "givetake1_a",             -- Animation clip for progress bar
            duration = 2500,                  -- Duration of the progress bar in milliseconds
        },
        --- npc animation
        npcanimation = {
            dict = "mp_common",               -- Animation dictionary for progress bar
            clip = "givetake1_a",             -- Animation clip for progress bar
        },
        ------------------------------------------------------------------------------------------
      


        --- Black Market configuration
        BlackMarket = {
            dealername = 'Johan',              -- Change the dealer name for notification
            id = "black_market",               -- Unique ID for the black market
            name = "Black Market",             -- Name of the shop
            model = "a_m_m_skater_01",         -- NPC model for the black market
            items = {                          -- List of items available for purchase
                { name = "lockpick", price = 100 },
                { name = "weapon_pistol", price = 500 },
                                               -- Add more items here
                                               -- { name = "item name", price = 500 },
            },
        },
    },
}
         -----------------------------------------------------------------------------------------
-- client/dealerconfig.lua


