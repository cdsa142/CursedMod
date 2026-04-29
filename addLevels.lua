local lovely = require "lovely"

function getLevels()
    print("getting new levels")
    local success = love.filesystem.mount("Mods/CursedMod.zip", "CursedMod", true)
    
    return love.filesystem.getDirectoryItems("CursedMod/CursedMod/res/maps")
end