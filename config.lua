Config = {}

Config.shops = {
    {
        position = {x = -1856.5321, y = -1224.4966, z = 13.0262},
        name = '24/7 Supermarkt',
        npc = {
            model = 'mp_m_shopkeep_01', -- Beispiel NPC-Modell
            position = {x = -1856.5321, y = -1224.4966, z = 12.0262, h = 331.9854}, -- NPC-Position und Ausrichtung (h für heading)
        }
    },
    {
        position = {x = -47.522, y = -1756.857, z = 29.421},
        name = 'Robs Liquor',
        npc = {
            model = 'mp_m_shopkeep_01',
            position = {x = -47.4, y = -1756.3, z = 28.4, h = 50.0},
        }
    },
    -- Füge hier weitere Shops mit NPCs hinzu
}

Config.shopItems = {
    {id = 'water', name = 'Wasser', price = 5},
    {id = 'bread', name = 'Brot', price = 3},
    -- Füge hier weitere Artikel hinzu
}
