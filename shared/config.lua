-- _____  ____   _   _  ______  _____  _____ 
-- / ____|/ __ \ | \ | ||  ____||_   _|/ ____|
-- | |    | |  | ||  \| || |__     | | | |  __ 
-- | |    | |  | || . ` ||  __|    | | | | |_ |
-- | |____| |__| || |\  || |      _| |_| |__| |
-- \_____|\____/ |_| \_||_|     |_____|\_____|

Config = {
    ----- interact -----  only 1 on true 
    target = false,     
    interact = true,
    --------------------
    lbphone = true,  ---- you use lbphone for the notification set on true
    debug = true,  -- True or false debug


    BlackMarket = {
        id = "black_market", 
        name = "Black Market",  -- Change the name from the shop
        items = {
            { name = "lockpick", price = 100 },  -- Item and price
            { name = "weapon_pistol", price = 500 },  
            --add more
            --- { name = "item name", price = 500 },  
        },
        model = "a_m_m_skater_01",  -- change npc model
        locations = {  -- add locations 
            {
                coords = vector3(285.08, -1005.15, 29.29),  
                
             --- only work if you use lbphone and set lbphone true   
                notification = { 
                    content = "Het is echt warm hier! Kom snel langs voor een deal!", --- change the twitter chat
                    attachments = {"https://example.com/image1.jpg"},  -- url change to your url 
                    hashtags = {"#Steeg", "#BlackMarket"} -- change the tags
                }
            },
            {
                coords = vector3(371.14, 71.63, 98.98),  

                  --- only work if you use lbphone and set lbphone true   
                notification = {
                    content = "Hier is een speciale aanbieding voor jou!", --- change the twitter chat
                    attachments = {"https://example.com/image2.jpg"},  -- url
                    hashtags = {"#Aanbieding", "#BlackMarket"} -- change the tags
                }
            },
            {
                coords = vector3(721.26, 1291.24, 359.3),  

                  --- only work if you use lbphone and set lbphone true   
                notification = {
                    content = "Kom snel langs, het is druk hier!", --- change the twitter chat
                    attachments = {"https://example.com/image3.jpg"},  -- url
                    hashtags = {"#Druk", "#BlackMarket"} -- change the tags
                }
            }
        },
        spawnInterval = 1, -- 1 = 1 min
    }
}