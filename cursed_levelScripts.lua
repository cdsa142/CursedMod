

local function addLevelScripts(level_scripts)
    level_scripts["CURSE-1"] = function (game)
        local scores = Scores.new()
        print("running CURSE-1 level script")
        if game.unlocks.flags["royal_boon2"] and scores.crown_data[game.level_data.metadata.name]==2 then
            game.level_data[9].entities[#game.level_data[9].entities+1] = {
                x = 15,
                y = 7,
                type = "rapier",
                value = 0,
                value_str = "",
            }
        end
        if not game.unlocks.flags["solar_boon"] then
            game.level_data[17].entities[#game.level_data[17].entities+1] = {
                x = 7,
                y = 7,
                type = "solar_boon",
                value = 0,
                value_str = "",
            }
        end

        if not game.unlocks.flags["lunar_boon"] then
            game.level_data[1].entities[#game.level_data[1].entities+1] = {
                x = 5,
                y = 13,
                type = "lunar_boon",
                value = 0,
                value_str = "",
            }
        end

        if game.unlocks.flags["solar_boon"] and scores.crown_data[game.level_data.metadata.name]==2 then
            game.level_data[5].entities[#game.level_data[5].entities+1] = {
                x = 3,
                y = 12,
                type = "solar_morningstar",
                value = 0,
                value_str = "",
            }
        end

        if game.unlocks.flags["lunar_boon"] and scores.crown_data[game.level_data.metadata.name]==2 then
            game.level_data[5].entities[#game.level_data[5].entities+1] = {
                x = 9,
                y = 12,
                type = "lunar_scimitar",
                value = 0,
                value_str = "",
            }
        end
    end
end

