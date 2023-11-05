-- <<<     CanX WELCOME     >>> --|
--    Discord : discord.gg/MGEVjBbKHw  --|                      
--        Tebex : canx.tebex.io        --|        
-- <<<     CanX WELCOME     >>> --|

Config = {}

Config.Framework = 'ESX' -- ESX - QB

Config.PedBuyIdCardModel = GetHashKey('a_m_y_business_03')

Config.PedLocation = { x = 215.69, y = -815.66, z = 29.66, h = 159.2 }

Config.TextDistance = 8.0

Config.Codes = { -- Creator codes !
    ['parzival'] = {
        Type = 'cash',
        Name = 'Cash',
        Amount = 5000,
    },
    ['parzival2'] = {
        Type = 'item',
        Name = 'phone',
        Amount = 5,
    },
    ['parzival3'] = {
        Type = 'vehicle',
        Name = 'neon',
    },
    ['parzival4'] = {
        Type = 'weapon',
        Name = 'weapon_pistol',
        Ammo = 250
    },
}

Config.DefaultReward = { -- Default reward
    Type = 'cash',
    Name = 'Cash',
    Amount = 50000,
}

Config.Locale = {
    logo = "/web/build/img/ok-hand_1f44c.png",
    svname = "GOOGLE",
    welcome = "Welcome",
    citizen = "CITIZENS",
    over = "OVER",
    claim_reward = "CLAIM REWARD",
    creator_code = "CREATOR CODE",
    go_back = "GO BACK",
    check_code = "CHECK CODE",
}
