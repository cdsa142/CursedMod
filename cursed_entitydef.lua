local util = require "util"

local function isEnemy(type)
    return type == "enemy" or type == "enemy_neg" or type == "mirror_enemy" or type == "mirror_enemy_neg"
end

local function findEnemyEntAtCoords(x, y, ents)
    for i=1,#ents do
        if ents[i] and ents[i].x == x and ents[i].y == y then
            if isEnemy(ents[i].type) or not ents[i].type then
                return i
            end
        end
    end
    return nil
end

local function dist(ent, ent2)
    return math.abs(ent.y - ent2.y) + math.abs(ent.x - ent2.x)
end

local function lunacyTrigger(ents, source)
    print("lunacy trigger")
    local chosenEnt = nil
    local furthestDist = 0
    for i=1,#ents do
        local ent_type = ents[i].type
        if ent_type == "enemy" or ent_type == "mirror_enemy" then
            local entity = ents[i]
            if not chosenEnt or dist(source, entity) >= furthestDist then
                if not chosenEnt or dist(source, entity) > furthestDist or entity.y > chosenEnt.y or (entity.y == chosenEnt.y and entity.x > chosenEnt.x) then
                   chosenEnt = entity
                   furthestDist = dist(source, entity) 
                   source.lunarAffectedEnt = i
                end
            end
        end
    end
    if chosenEnt then
        if not chosenEnt.lunarHistory then
            chosenEnt.lunarHistory = {}
            chosenEnt.lunacyStacks = {0}
        end
        local originalValue = chosenEnt.value
        table.insert(chosenEnt.lunarHistory, originalValue)
        local lunacyStacks = chosenEnt.lunacyStacks[#chosenEnt.lunacyStacks] + 1
        local newValue = originalValue * 1.2 ^ lunacyStacks
        print("lunacy from " .. originalValue .. " to " .. newValue)
        local roundedVal = util.roundVal(newValue)
        if originalValue ~= roundedVal then
            lunacyStacks = 0
        end
        table.insert(chosenEnt.lunacyStacks, lunacyStacks)
        chosenEnt.value = roundedVal
        chosenEnt.value_str = util.getValueString(roundedVal)
    end
end

local function solarTrigger(ents, source)
    print("solar trigger")
    local chosenEnt = nil
    local closestDist = 9999
    for i=1,#ents do
        local ent_type = ents[i].type
        if ents[i] ~= source and (ent_type == "enemy_neg" or ent_type == "mirror_enemy_neg") then
            local entity = ents[i]
            if not chosenEnt or dist(source, entity) <= closestDist then
                if not chosenEnt or dist(source, entity) < closestDist or entity.y < chosenEnt.y or (entity.y == chosenEnt.y and entity.x < chosenEnt.x) then
                    chosenEnt = entity
                    closestDist = dist(source, entity)
                    source.solarAffectedEnt = i
                end
            end
        end
    end
    if chosenEnt then
        if not chosenEnt.solarHistory then
            chosenEnt.solarHistory = {}
        end
        local originalValue = chosenEnt.value
        table.insert(chosenEnt.solarHistory, originalValue)
        local newValue = math.max(originalValue * 0.8, 1)
        print("solar from " .. originalValue .. " to " .. newValue)
        local roundedVal = util.roundVal(newValue)
        chosenEnt.value = roundedVal
        chosenEnt.value_str = util.getValueString(roundedVal)
    end
end

local function addCursedEntities(entitydef)
    entitydef.mirror_enemy = {
        compendium_header = "Mirror Enemies",
        spr = {
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_slime.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_bat.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_snake.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_scorpion.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_skeleton.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_zombie.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_skeleton_warrior.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_armor.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_warlock.png"),
            love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_demon.png"),
        },
        get_spr = function(ent)
            if ent == nil then
                return entitydef.mirror_enemy.spr[1]
            end
            if ent.value >= 1000000000 then
                return entitydef.mirror_enemy.spr[10]
            end
            if ent.value >= 100000000 then
                return entitydef.mirror_enemy.spr[9]
            end
            if ent.value >= 10000000 then
                return entitydef.mirror_enemy.spr[8]
            end
            if ent.value >= 1000000 then
                return entitydef.mirror_enemy.spr[7]
            end
            if ent.value >= 100000 then
                return entitydef.mirror_enemy.spr[6]
            end
            if ent.value >= 10000 then
                return entitydef.mirror_enemy.spr[5]
            end
            if ent.value >= 1000 then
                return entitydef.mirror_enemy.spr[4]
            end
            if ent.value >= 100 then
                return entitydef.mirror_enemy.spr[3]
            end
            if ent.value >= 10 then
                return entitydef.mirror_enemy.spr[2]
            end
            return entitydef.mirror_enemy.spr[1]
        end,
        can_interact = function(ent, game)
            if game.player.power > ent.value or game.player.held_item == "vorpal"  then
                return true
            end
        end,
        undo_store = function(ent, game)
            local out = {
                battle_gates = {}
            }
            local floor_ents = game.level_data[game.player.floor].entities
            for i=1,#floor_ents do
                if floor_ents[i].type == "battle_gate" then
                    out.battle_gates[#out.battle_gates+1] = floor_ents[i]
                end
            end
            return out
        end,
        interact = function(ent, game)
            game.unlocks:set_unlock_flag("compendium_mirror_enemies")
            if game.level_data.metadata.computed_flags.money_system then
                game.unlocks:set_unlock_flag("compendium_flag_money")
            end
            if game.player.held_item == "vorpal" then
                log("vorpal sword consumed")
                local a = game:spawn_anim("kill_vorpal",ent.x*16-12,ent.y*16-12)
                g_sfx:play("hit_vorpal")
                a.params = {
                    dir_x = ent.x - game.player.x,
                    dir_y = ent.y - game.player.y,
                }
                game.player.held_item = nil
            elseif game.player.held_item == "dark_rod" then
                log("dark rod consumed")
                game:spawn_anim("kill_drod",ent.x*16-12,ent.y*16-12)
                g_sfx:play("hit_rod")
                game.player.held_item = nil
                game:modify_player_power(ent.value*2)
            elseif game.player.held_item == "shield" then
                game:modify_player_power(math.floor(ent.value/2))
                local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
                g_sfx:play("hit")
                a.params = {
                    dir_x = ent.x - game.player.x,
                    dir_y = ent.y - game.player.y,
                }
            elseif game.player.held_item == "keysmasher" then
                if game.flags.negative_keys then
                    game:modify_player_power(ent.value + game.player.keys * game.player.keys)
                else
                    game:modify_player_power(ent.value + game.player.keys * game.player.dark_keys)
                end
                local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
                g_sfx:play("hit")
                a.params = {
                    dir_x = ent.x - game.player.x,
                    dir_y = ent.y - game.player.y,
                }
            elseif game.player.held_item == "rapier" then
                local tier = 1
                local val = ent.value
                while val>=10 and tier<=10 do
                    tier = tier + 1
                    val = val /10
                end
                game:modify_player_power(ent.value + game.player.total_crowns * tier)
                local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
                g_sfx:play("hit")
                a.params = {
                    dir_x = ent.x - game.player.x,
                    dir_y = ent.y - game.player.y,
                }
            else
                game:modify_player_power(ent.value)
                local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
                g_sfx:play("hit")
                a.params = {
                    dir_x = ent.x - game.player.x,
                    dir_y = ent.y - game.player.y,
                }
            end
            local val_tmp = ent.value
            local money_gain = 1
            while val_tmp >= 10 and money_gain < 10 do
                val_tmp = val_tmp / 10
                money_gain = money_gain + 1
            end
            if game.player.held_item == "golden_dagger" then
                money_gain = money_gain + 2
            elseif game.player.held_item == "golden_claymore" then
                money_gain = money_gain * 2
            end
            game.player.gold = game.player.gold + money_gain
            ent.type = nil
            --battle gates
            local floor_ents = game.level_data[game.player.floor].entities
            if game.player.held_item == "lunar_scimitar" then
                lunacyTrigger(floor_ents, ent)
            end
            local play_door_sound = false
            for i=1,#floor_ents do
                if floor_ents[i].type == "battle_gate" then
                    floor_ents[i].value = floor_ents[i].value - 1
                    floor_ents[i].value_str = ""..floor_ents[i].value
                    if floor_ents[i].value == 0 then
                        log("battle gate at "..(floor_ents[i].x)..","..(floor_ents[i].y).." opened")
                        play_door_sound = true
                        game:spawn_anim("open",floor_ents[i].x*16-12,floor_ents[i].y*16-12)
                        floor_ents[i].type = nil
                    end
                    game.unlocks:set_unlock_flag("compendium_flag_bgate")
                end
            end
            if play_door_sound then
                g_sfx:play("key_door")
            end
            ent.spawnedEntId = findEnemyEntAtCoords(game.player.x, game.player.y, floor_ents)
            if not ent.spawnedEntId then
                print("no entity at coords " .. game.player.x .. " " .. game.player.y .. ". Creating a new entity")
                ent.spawnedEntId = #floor_ents + 1
                table.insert(floor_ents, {})
            end
            local spawnedEnt = floor_ents[ent.spawnedEntId]
            ent.prevEntValue = spawnedEnt.value
            spawnedEnt.x = game.player.x
            spawnedEnt.y = game.player.y
            spawnedEnt.type = "enemy_neg"
            spawnedEnt.value = ent.value
            spawnedEnt.value_str = ent.value_str
            return true
        end,
        undo_perform = function(ent, game, extra_data)
            if ent.lunarAffectedEnt then
                local lunarEnt = game.level_data[game.player.floor].entities[ent.lunarAffectedEnt]
                local lastVal = table.remove(lunarEnt.lunarHistory)
                table.remove(lunarEnt.lunacyStacks)
                lunarEnt.value = lastVal
                lunarEnt.value_str = util.getValueString(lastVal)    
            end
            ent.type = "mirror_enemy"
            game.level_data[game.player.floor].entities[ent.spawnedEntId].type = nil
            if ent.prevEntValue then
                game.level_data[game.player.floor].entities[ent.spawnedEntId].value = ent.prevEntValue
                game.level_data[game.player.floor].entities[ent.spawnedEntId].value_str = util.getValueString(ent.prevEntValue)
            end
            for i=1,#extra_data.battle_gates do
                extra_data.battle_gates[i].type = "battle_gate"
                extra_data.battle_gates[i].value = extra_data.battle_gates[i].value + 1
                extra_data.battle_gates[i].value_str = ""..extra_data.battle_gates[i].value
            end
        end,
    }

    entitydef.mirror_enemy_neg = {
    compendium_header = "Mirror Enemies",
    spr = {
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_slime_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_bat_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_snake_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_scorpion_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_skeleton_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_zombie_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_skeleton_warrior_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_armor_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_warlock_neg.png"),
        love.graphics.newImage("CursedMod/CursedMod/res/sprite/mirror_enemy_demon_neg.png"),
    },
    get_spr = function(ent)
        if ent == nil then
            return entitydef.mirror_enemy_neg.spr[1]
        end
        if ent.value >= 1000000000 then
            return entitydef.mirror_enemy_neg.spr[10]
        end
        if ent.value >= 100000000 then
            return entitydef.mirror_enemy_neg.spr[9]
        end
        if ent.value >= 10000000 then
            return entitydef.mirror_enemy_neg.spr[8]
        end
        if ent.value >= 1000000 then
            return entitydef.mirror_enemy_neg.spr[7]
        end
        if ent.value >= 100000 then
            return entitydef.mirror_enemy_neg.spr[6]
        end
        if ent.value >= 10000 then
            return entitydef.mirror_enemy_neg.spr[5]
        end
        if ent.value >= 1000 then
            return entitydef.mirror_enemy_neg.spr[4]
        end
        if ent.value >= 100 then
            return entitydef.mirror_enemy_neg.spr[3]
        end
        if ent.value >= 10 then
            return entitydef.mirror_enemy_neg.spr[2]
        end
        return entitydef.mirror_enemy_neg.spr[1]
    end,
    can_interact = function(ent, game)
        if game.player.power > ent.value or game.player.held_item == "vorpal" then
            return true
        end
    end,
    undo_store = function(ent, game)
        local out = {
            battle_gates = {}
        }
        local floor_ents = game.level_data[game.player.floor].entities
        for i=1,#floor_ents do
            if floor_ents[i].type == "battle_gate" then
                out.battle_gates[#out.battle_gates+1] = floor_ents[i]
            end
        end
        return out
    end,
    interact = function(ent, game)
        game.unlocks:set_unlock_flag("compendium_mirror_enemies")
        if game.level_data.metadata.computed_flags.money_system then
            game.unlocks:set_unlock_flag("compendium_flag_money")
        end
        if game.player.held_item == "vorpal" then
            log("vorpal sword consumed")
            local a = game:spawn_anim("kill_vorpal",ent.x*16-12,ent.y*16-12)
            g_sfx:play("hit_vorpal")
            a.params = {
                dir_x = ent.x - game.player.x,
                dir_y = ent.y - game.player.y,
            }
            game.player.held_item = nil
        elseif game.player.held_item == "light_rod" then
            log("light rod consumed")
            game:spawn_anim("kill_lrod",ent.x*16-12,ent.y*16-12)
            g_sfx:play("hit_rod")
            game.player.held_item = nil
            game:modify_player_power(ent.value)
        elseif game.player.held_item == "shield" then
            game:modify_player_power(-math.floor(ent.value/2))
            local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
            g_sfx:play("hit")
            a.params = {
                dir_x = ent.x - game.player.x,
                dir_y = ent.y - game.player.y,
            }
        elseif game.player.held_item == "keysmasher" then
            if game.flags.negative_keys then
                game:modify_player_power(-ent.value + game.player.keys * game.player.keys)
            else
                game:modify_player_power(-ent.value + game.player.keys * game.player.dark_keys)
            end
            local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
            g_sfx:play("hit")
            a.params = {
                dir_x = ent.x - game.player.x,
                dir_y = ent.y - game.player.y,
            }
        elseif game.player.held_item == "rapier" then
            local tier = 1
            local val = ent.value
            while val>=10 and tier<=10 do
                tier = tier + 1
                val = val /10
            end
            game:modify_player_power(-ent.value + game.player.total_crowns * tier)
            local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
            g_sfx:play("hit")
            a.params = {
                dir_x = ent.x - game.player.x,
                dir_y = ent.y - game.player.y,
            }
        else
            game:modify_player_power(-ent.value)
            local a = game:spawn_anim("kill_normal",ent.x*16-12,ent.y*16-12)
            g_sfx:play("hit")
            a.params = {
                dir_x = ent.x - game.player.x,
                dir_y = ent.y - game.player.y,
            }
        end
        local val_tmp = ent.value
        local money_gain = 1
        while val_tmp >= 10 and money_gain < 10 do
            val_tmp = val_tmp / 10
            money_gain = money_gain + 1
        end
        if game.player.held_item == "golden_dagger" then
            money_gain = money_gain + 2
        elseif game.player.held_item == "golden_claymore" then
            money_gain = money_gain * 2
        end
        game.player.gold = game.player.gold + money_gain
        ent.type = nil
        --battle gates
        local floor_ents = game.level_data[game.player.floor].entities
        if game.player.held_item == "solar_morningstar" then
            solarTrigger(floor_ents, ent)
        end
        local play_door_sound = false
        for i=1,#floor_ents do
            if floor_ents[i].type == "battle_gate" then
                floor_ents[i].value = floor_ents[i].value - 1
                floor_ents[i].value_str = ""..floor_ents[i].value
                if floor_ents[i].value == 0 then
                    log("battle gate at "..(floor_ents[i].x)..","..(floor_ents[i].y).." opened")
                    play_door_sound = true
                    game:spawn_anim("open",floor_ents[i].x*16-12,floor_ents[i].y*16-12)
                    floor_ents[i].type = nil
                end
                game.unlocks:set_unlock_flag("compendium_flag_bgate")
            end
        end
        if play_door_sound then
            g_sfx:play("key_door")
        end
        ent.spawnedEntId = findEnemyEntAtCoords(game.player.x, game.player.y, floor_ents)        
        if not ent.spawnedEntId then
            print("no entity at coords " .. game.player.x .. " " .. game.player.y.. ". Creating a new entity")
            ent.spawnedEntId = #floor_ents + 1
            table.insert(floor_ents, {})
        end
        local spawnedEnt = floor_ents[ent.spawnedEntId]
        ent.prevEntValue = spawnedEnt.value
        spawnedEnt.x = game.player.x
        spawnedEnt.y = game.player.y
        spawnedEnt.type = "enemy"
        spawnedEnt.value = ent.value
        spawnedEnt.value_str = ent.value_str
        return true
    end,
    undo_perform = function(ent, game, extra_data)
        if ent.solarAffectedEnt then
            local solarEnt = game.level_data[game.player.floor].entities[ent.solarAffectedEnt]
            local lastVal = table.remove(solarEnt.solarHistory)
            solarEnt.value = lastVal
            solarEnt.value_str = util.getValueString(lastVal)    
        end
        ent.type = "mirror_enemy_neg"
        game.level_data[game.player.floor].entities[ent.spawnedEntId].type = nil
        if ent.prevEntValue then
            game.level_data[game.player.floor].entities[ent.spawnedEntId].value = ent.prevEntValue
            game.level_data[game.player.floor].entities[ent.spawnedEntId].value_str = util.getValueString(ent.prevEntValue)
        end
        for i=1,#extra_data.battle_gates do
            extra_data.battle_gates[i].type = "battle_gate"
            extra_data.battle_gates[i].value = extra_data.battle_gates[i].value + 1
            extra_data.battle_gates[i].value_str = ""..extra_data.battle_gates[i].value
        end
    end,
}

    entitydef.curse_weaken = {
        compendium_header = "Light Curses",
        particle = util.standard_particle_spawner,
        spr = love.graphics.newImage("CursedMod/CursedMod/res/sprite/sun.png"),
        can_interact = function(ent, game)
            return true
        end,
        undo_store = function(ent, game)
            return {}
        end,
        interact = function(ent, game)
            log("weaken curse activated")
            game.unlocks:set_unlock_flag("compendium_curse_weaken")
            local floor_ents = game.level_data[game.player.floor].entities
            for i=1,#floor_ents do
                local ent_type = floor_ents[i].type
                if isEnemy(ent_type) then
                    local entity = floor_ents[i]
                    if not entity.curseHistory then
                        entity.curseHistory = {}
                    end
                    table.insert(entity.curseHistory, entity.value)
                    if not entity.value or entity.value < 10 then
                        entity.value = 1
                        entity.value_str = "1"
                    else
                       entity.value = util.roundVal(entity.value / 10)
                       entity.value_str = util.getValueString(entity.value)
                    end
                end
            end

            game:spawn_anim("elixir",ent.x*16-12,ent.y*16-12)
            g_sfx:play("elixir")
            ent.type = nil
            return true
        end,
        undo_perform = function(ent, game, extra_data)
            ent.type = "curse_weaken"
            local floor_ents = game.level_data[game.player.floor].entities
            for i=1,#floor_ents do
                local ent_type = floor_ents[i].type
                if isEnemy(ent_type) then
                    local entity = floor_ents[i]
                    if entity.curseHistory then
                        local lastVal = table.remove(entity.curseHistory)
                        entity.value = lastVal
                        entity.value_str = util.getValueString(lastVal)    
                    else
                        log("curseHistory missing. Falling back to x10")
                        local lastVal = util.roundVal(entity.value * 10)
                        entity.value = lastVal
                        entity.value_str = util.getValueString(lastVal)
                    end
                end
            end
        end,
    }

    entitydef.curse_strengthen = {
        compendium_header = "Dark Curses",
        particle = util.standard_particle_spawner,
        spr = love.graphics.newImage("CursedMod/CursedMod/res/sprite/moon.png"),
        can_interact = function(ent, game)
            return true
        end,
        undo_store = function(ent, game)
            return {}
        end,
        interact = function(ent, game)
            log("strengthen curse activated")
            game.unlocks:set_unlock_flag("compendium_curse_strengthen")
            local floor_ents = game.level_data[game.player.floor].entities
            for i=1,#floor_ents do
                local ent_type = floor_ents[i].type
                if isEnemy(ent_type) then
                    local entity = floor_ents[i]
                    if not entity.curseHistory then
                        entity.curseHistory = {}
                    end
                    table.insert(entity.curseHistory, entity.value)
                    if not entity.value then
                        entity.value = 1
                        entity.value_str = "1"
                    elseif entity.value * 10 > MAX_POWER then
                        entity.value = MAX_POWER
                        entity.value_str = util.getValueString(entity.value)
                    else
                       entity.value = util.roundVal(entity.value * 10)
                       entity.value_str = util.getValueString(entity.value)
                    end
                end
            end

            game:spawn_anim("curse_weaken",ent.x*16-12,ent.y*16-12)
            g_sfx:play("hit_rod")
            ent.type = nil
            return true
        end,
        undo_perform = function(ent, game, extra_data)
            ent.type = "curse_strengthen"
            local floor_ents = game.level_data[game.player.floor].entities
            for i=1,#floor_ents do
                local ent_type = floor_ents[i].type
                if isEnemy(ent_type) then
                    local entity = floor_ents[i]
                    if entity.curseHistory then
                        local lastVal = table.remove(entity.curseHistory)
                        entity.value = lastVal
                        entity.value_str = util.getValueString(lastVal)    
                    else
                        log("curseHistory missing. Falling back to x10")
                        local lastVal = util.roundVal(entity.value * 10)
                        entity.value = lastVal
                        entity.value_str = util.getValueString(lastVal)
                    end
                end
            end
        end,
    }

    entitydef.solar_boon = {
        particle = util.unlock_particle_spawner,
        spr = love.graphics.newImage("CursedMod/CursedMod/res/sprite/Solar_Boon.png"),
        can_interact = function(ent, game)
            return true
        end,
        interact = function(ent, game)
            game.unlocks:set_unlock_flag("compendium_royal_boons")
            game.unlocks:set_unlock_flag("solar_boon")
            game:clear_anim()
            game:spawn_anim("perma_unlock",ent.x*16-12,ent.y*16-12)
            game.player.total_gems = util.get_total_gems()
            game:show_dialog("alert","ROYAL BOON OBTAINED!\n\n[Lessons from the Light Lord]\n\nStarting from now, a held item Solar Morningstar will spawn somewhere on the stages in which you have obtained a Dark Crown.\nCheck compendium for details!",232,108,{(function(s) s.substate = 0 end)})
            ent.type = nil
            return true
        end,
    }
    entitydef.lunar_boon = {
        particle = util.unlock_particle_spawner,
        spr = love.graphics.newImage("CursedMod/CursedMod/res/sprite/Lunar_Boon.png"),
        can_interact = function(ent, game)
            return true
        end,
        interact = function(ent, game)
            game.unlocks:set_unlock_flag("compendium_royal_boons")
            game.unlocks:set_unlock_flag("lunar_boon")
            game:clear_anim()
            game:spawn_anim("perma_unlock",ent.x*16-12,ent.y*16-12)
            game.player.total_gems = util.get_total_gems()
            game:show_dialog("alert","ROYAL BOON OBTAINED!\n\n[Prize of the Deep King]\n\nStarting from now, a held item Scimitar of Lunacy will spawn somewhere on the stages in which you have obtained a Dark Crown.\nCheck compendium for details!",232,108,{(function(s) s.substate = 0 end)})
            ent.type = nil
            return true
        end,
    }

    entitydef.solar_morningstar = {
    compendium_header = "Solar Morningstar",
    particle = util.standard_particle_spawner,
    spr = love.graphics.newImage("CursedMod/CursedMod/res/sprite/solar_morningstar.png"),
    can_interact = function(ent, game)
        return true
    end,
    undo_store = function(ent, game)
        return {}
    end,
    interact = function(ent, game)
        log("solar morningstar obtained")
        game.player.held_item = "solar_morningstar"
        g_sfx:play("equip")
        ent.type = nil
        return true
    end,
    undo_perform = function(ent, game, extra_data)
        ent.type = "solar_morningstar"
    end,
}

entitydef.lunar_scimitar = {
    compendium_header = "Scimitar of Lunacy",
    particle = util.standard_particle_spawner,
    spr = love.graphics.newImage("CursedMod/CursedMod/res/sprite/scimitar_of_lunacy.png"),
    can_interact = function(ent, game)
        return true
    end,
    undo_store = function(ent, game)
        return {}
    end,
    interact = function(ent, game)
        log("scimitar of lunacy obtained")
        game.player.held_item = "lunar_scimitar"
        g_sfx:play("equip")
        ent.type = nil
        return true
    end,
    undo_perform = function(ent, game, extra_data)
        ent.type = "lunar_scimitar"
    end,
}


end

