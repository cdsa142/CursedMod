local entitydef = require "entitydef"

local function addCompendiumPages(pages)
    table.insert(pages, 
        {
        {
            unlock_flag = "compendium_mirror_enemies",
            spr = entitydef.mirror_enemy.spr[4],
            header = "Mirror Enemies",
            content =
            "CURSE MOD - Mirror enemies can be either positive or negative. After defeating them, the inverse spawns where the player was."
        },
    })
    table.insert(pages, 
    {
        {
            unlock_flag = "compendium_curse_weaken",
            spr = entitydef.curse_weaken.spr,
            header = "Light Curses",
            content =
            "CURSE MOD\nLight curses reduce the power of all enemies on the floor by one tier ( /10). Multiple curses can be in effect at once."
        },
        {
            unlock_flag = "compendium_curse_strengthen",
            spr = entitydef.curse_strengthen.spr,
            header = "Dark Curses",
            content =
            "CURSE MOD\nDark curses increase the power of all enemies on the floor by one tier ( x10). Multiple curses can be in effect at once. Some rounding will occur when the unit changes (k -> M will lose some precision)."
        },
    })
    table.insert(pages, 
    {
        {
            unlock_flag = "solar_boon",
            spr = entitydef.solar_boon.spr,
            header = "Lessons from the Light Lord",
            content =
            "CURSE MOD\nThis Royal Boon spawns a special held item - the Solar Morningstar - somewhere on each stage where you have obtained a Dark Crown."
        },
        {
            unlock_flag = "lunar_boon",
            spr = entitydef.lunar_boon.spr,
            header = "Prize of the Deep King",
            content =
            "CURSE MOD\nThis Royal Boon spawns a special held item - the Scimitar of Lunacy - somewhere on each stage where you have obtained a Dark Crown."
        },
    })
    table.insert(pages, 
    {
        {
            unlock_flag = "solar_boon",
            spr = entitydef.solar_morningstar.spr,
            header = "Solar Morningstar",
            content =
            "CURSE MOD\n While you are holding the Solar Morningstar, defeating a negative enemy will slightly (80%) weaken the closest negative enemy. Rounding will occur so the displayed value is the real value."
        },
        {
            unlock_flag = "lunar_boon",
            spr = entitydef.lunar_scimitar.spr,
            header = "Scimitar of Lunacy",
            content =
            "CURSE MOD\nWhile you are holding the Scimitar of Lunacy, defeating a positive enemy will slightly (120%) strengthen the furthest positive enemy. Lunacy effects may stack and apply together (a 3k enemy with 2 lunacy stacks would become a 4k)."
        }          
    })
    
end

