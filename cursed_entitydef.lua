local util = require "util"

local function addCursedEntities(entitydef)
    entitydef.mirror_enemy = {
        compendium_header = "Enemies",
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
            game.unlocks:set_unlock_flag("compendium_flag_enemy")
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
            
            if not ent.spawnedEntId then
                ent.spawnedEntId = #floor_ents + 1
                table.insert(floor_ents, {})
            end
            local spawnedEnt = floor_ents[ent.spawnedEntId]
            spawnedEnt.x = game.player.x
            spawnedEnt.y = game.player.y
            spawnedEnt.type = "enemy_neg"
            spawnedEnt.value = ent.value
            spawnedEnt.value_str = ent.value_str
            return true
        end,
        undo_perform = function(ent, game, extra_data)
            ent.type = "mirror_enemy"
            game.level_data[game.player.floor].entities[ent.spawnedEntId].type = nil
            for i=1,#extra_data.battle_gates do
                extra_data.battle_gates[i].type = "battle_gate"
                extra_data.battle_gates[i].value = extra_data.battle_gates[i].value + 1
                extra_data.battle_gates[i].value_str = ""..extra_data.battle_gates[i].value
            end
        end,
    }

    entitydef.curse_weaken = {
        compendium_header = "Elixirs",
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
            
            local floor_ents = game.level_data[game.player.floor].entities
            for i=1,#floor_ents do
                local ent_type = floor_ents[i].type
                if ent_type == "enemy" or ent_type == "enemy_neg" or ent_type == "mirror_enemy" or ent_type == "mirror_enemy_neg" then
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
                if ent_type == "enemy" or ent_type == "enemy_neg" or ent_type == "mirror_enemy" or ent_type == "mirror_enemy_neg" then
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
        compendium_header = "Elixirs",
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
            
            local floor_ents = game.level_data[game.player.floor].entities
            for i=1,#floor_ents do
                local ent_type = floor_ents[i].type
                if ent_type == "enemy" or ent_type == "enemy_neg" or ent_type == "mirror_enemy" or ent_type == "mirror_enemy_neg" then
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
                if ent_type == "enemy" or ent_type == "enemy_neg" or ent_type == "mirror_enemy" or ent_type == "mirror_enemy_neg" then
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
end

