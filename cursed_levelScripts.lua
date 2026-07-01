

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

    level_scripts["CURSE-2"] = function (game)
        local scores = Scores.new()
        if game.unlocks.flags["royal_boon2"] and scores.crown_data[game.level_data.metadata.name]==2 then
            game.level_data[25].entities[#game.level_data[25].entities+1] = {
                x = 13,
                y = 3,
                type = "rapier",
                value = 0,
                value_str = "",
            }
        end

        if game.unlocks.flags["solar_boon"] and scores.crown_data[game.level_data.metadata.name]==2 then
            game.level_data[25].entities[#game.level_data[25].entities+1] = {
                x = 15,
                y = 1,
                type = "solar_morningstar",
                value = 0,
                value_str = "",
            }
        end

        if game.unlocks.flags["lunar_boon"] and scores.crown_data[game.level_data.metadata.name]==2 then
            game.level_data[25].entities[#game.level_data[25].entities+1] = {
                x = 15,
                y = 15,
                type = "lunar_scimitar",
                value = 0,
                value_str = "",
            }
        end
    end

    level_scripts["CURSE-CH1-Rush"] = function (game)
        local scores = Scores.new()
        if game.unlocks.flags["royal_boon2"] and scores.crown_data['1-1: Training Tower']==2 then
            game.level_data[7].entities[#game.level_data[7].entities+1] = {
                x = 11,
                y = 8,
                type = "rapier",
                value = 0,
                value_str = "",
            }
            game.level_data[7].walls[10][7] = 0
            game.level_data[7].walls[11][7] = 0
            game.level_data[7].walls[12][7] = 0
            game.level_data[7].walls[10][8] = 0
            game.level_data[7].walls[11][8] = 0
            game.level_data[7].walls[12][8] = 0
            game.level_data[7].walls[10][9] = 0
            game.level_data[7].walls[11][9] = 0
            game.level_data[7].walls[12][9] = 0
            game.level_data[7].walls[9][8] = 0
            game.level_data[7].walls[8][8] = 0
            game.level_data[7].walls[7][8] = 0
            game.level_data[7].walls[6][8] = 0
            game.level_data[7].walls[5][8] = 0
        end
        if game.unlocks.flags["royal_boon2"] and scores.crown_data['1-2: Tower of Might']==2 then
            game.level_data[30].entities[#game.level_data[30].entities+1] = {
                x = 5,
                y = 15,
                type = "rapier",
                value = 0,
                value_str = "",
            }
            game.level_data[30].walls[4][14] = 0
            game.level_data[30].walls[5][14] = 0
            game.level_data[30].walls[4][15] = 0
            game.level_data[30].walls[5][15] = 0
            game.level_data[30].walls[6][15] = 0
        end
        if game.unlocks.flags["royal_boon2"] and scores.crown_data['1-3: Tower of Traps']==2 then
            game.level_data[49].entities[#game.level_data[49].entities+1] = {
                x = 15,
                y = 8,
                type = "rapier",
                value = 0,
                value_str = "",
            }
            game.level_data[49].walls[14][7] = 0
            game.level_data[49].walls[15][7] = 0
            game.level_data[49].walls[15][8] = 0
        end
        if game.unlocks.flags["royal_boon2"] and scores.crown_data["1-4: Miner's Obelisk"]==2 then
            game.level_data[61].entities[#game.level_data[61].entities+1] = {
                x = 14,
                y = 8,
                type = "rapier",
                value = 0,
                value_str = "",
            }
            game.level_data[61].walls[14][8] = 0
        end
        if game.unlocks.flags["royal_boon2"] and scores.crown_data["1-5: Tiny Tower"]==2 then
            game.level_data[80].entities[#game.level_data[80].entities+1] = {
                x = 13,
                y = 2,
                type = "rapier",
                value = 0,
                value_str = "",
            }
            game.level_data[80].walls[13][2] = 0
        end
        if game.unlocks.flags["royal_boon2"] and scores.crown_data["1-6: Adventurer's Exam"]==2 then
            game.level_data[91].entities[#game.level_data[91].entities+1] = {
                x = 1,
                y = 7,
                type = "rapier",
                value = 0,
                value_str = "",
            }
            game.level_data[91].walls[1][7] = 0
        end
    end
end


