inf = 1e309

-- MINE

hub_rednet_side            = 'top'
turtle_timeout             = 5
pocket_timeout             = 5
task_timeout               = 0.5
grid_width                 = 8
fuel_padding               = 30
fuel_per_unit              = 80
mission_length             = 150
vein_max                   = 64
dig_blacklist              = {'computer', 'chest', 'chair'}

mine_levels = {
    {level = 52, chance = 1.0},
}

paths = {
    home_to_home_exit                 = 'zyx',
    control_room_to_home_enter        = 'xyz',
    home_to_waiting_room              = 'zyx',
    waiting_room_to_mine_exit         = 'yzx',
    mine_enter_to_strip               = 'yxz',
}

locations = {
    mine_enter                 = {x = 375, y = 70, z = 1060},
    mine_exit                  = {x = 375, y = 71, z = 1061},
    item_drop                  = {x = 377, y = 71, z = 1061, orientation = 'east'},
    refuel                     = {x = 377, y = 71, z = 1060, orientation = 'east'},
    greater_home_area          = {min_x = -inf, max_x = 372, min_y = 70, max_y = 71, min_z = 1059, max_z = 1062},
    control_room_area          = {min_x = 369, max_x = 381, min_y = 70, max_y = 72, min_z = 1048, max_z = 1063},
    waiting_room_line_area     = {min_x = -inf, max_x = 373, min_y = 70, max_y = 70, min_z = 1060, max_z = 1061},
    waiting_room_area          = {min_x = 373, max_x = 375, min_y = 70, max_y = 70, min_z = 1060, max_z = 1061},
    main_loop_route = {
        ['374,71,1059'] = {x = 373, y = 71, z = 1059}, -- MINING TURTLE HOME ENTER
        ['373,71,1059'] = {x = 373, y = 71, z = 1060}, -- MINING TURTLE HOME EXIT
        ['373,71,1060'] = {x = 373, y = 71, z = 1061}, -- CHUNKY TURTLE HOME EXIT
        ['373,71,1061'] = {x = 373, y = 71, z = 1062}, -- CHUNKY TURTLE HOME ENTER
        ['373,71,1062'] = {x = 374, y = 71, z = 1062},
        ['374,71,1062'] = {x = 375, y = 71, z = 1062},
        ['375,71,1062'] = {x = 375, y = 71, z = 1061},
        ['375,71,1061'] = {x = 376, y = 71, z = 1061},
        ['376,71,1061'] = {x = 377, y = 71, z = 1061}, -- ITEM DROP STATION
        ['377,71,1061'] = {x = 377, y = 71, z = 1060}, -- REFUELING STATION
        ['377,71,1060'] = {x = 377, y = 71, z = 1059},
        ['377,71,1059'] = {x = 376, y = 71, z = 1059},
        ['376,71,1059'] = {x = 375, y = 71, z = 1059},
        ['375,71,1059'] = {x = 374, y = 71, z = 1059},
    },
}

mining_turtle_locations = {
    homes            = {x = 372, y = 70, z = 1059, increment = 'west'},
    home_area        = {min_x = -inf, max_x = 372, min_y = 70, max_y = 70, min_z = 1059, max_z = 1059},
    home_enter       = {x = 373, y = 71, z = 1059, orientation = 'west'},
    home_exit        = {x = 373, y = 71, z = 1060},
    waiting_room     = {x = 373, y = 70, z = 1060},
    waiting_room_to_mine_enter_route = {
        ['373,70,1060'] = {x = 374, y = 70, z = 1060},
        ['374,70,1060'] = {x = 375, y = 70, z = 1060},
    }
}

chunky_turtle_locations = {
    homes            = {x = 372, y = 70, z = 1062, increment = 'west'},
    home_area        = {min_x = -inf, max_x = 372, min_y = 70, max_y = 70, min_z = 1062, max_z = 1062},
    home_enter       = {x = 373, y = 71, z = 1062, orientation = 'west'},
    home_exit        = {x = 373, y = 71, z = 1061},
    waiting_room     = {x = 373, y = 70, z = 1061},
    waiting_room_to_mine_enter_route = {
        ['373,70,1061'] = {x = 374, y = 70, z = 1061},
        ['374,70,1061'] = {x = 374, y = 70, z = 1060},
        ['374,70,1060'] = {x = 375, y = 70, z = 1060},
    }
}

gravitynames = {
    ['minecraft:gravel'] = true,
    ['minecraft:sand'] = true,
}

orenames = {
    ['BigReactors:YelloriteOre'] = true,
    ['bigreactors:oreyellorite'] = true,
    ['DraconicEvolution:draconiumDust'] = true,
    ['DraconicEvolution:draconiumOre'] = true,
    ['Forestry:apatite'] = true,
    ['Forestry:resources'] = true,
    ['IC2:blockOreCopper'] = true,
    ['IC2:blockOreLead'] = true,
    ['IC2:blockOreTin'] = true,
    ['IC2:blockOreUran'] = true,
    ['ic2:resource'] = true,
    ['ProjRed|Core:projectred.core.part'] = true,
    ['ProjRed|Exploration:projectred.exploration.ore'] = true,
    ['TConstruct:SearedBrick'] = true,
    ['ThermalFoundation:Ore'] = true,
    ['thermalfoundation:ore'] = true,
    ['thermalfoundation:ore_fluid'] = true,
    ['thaumcraft:ore_amber'] = true,
    ['minecraft:coal'] = true,
    ['minecraft:coal_ore'] = true,
    ['minecraft:diamond'] = true,
    ['minecraft:diamond_ore'] = true,
    ['minecraft:dye'] = true,
    ['minecraft:emerald'] = true,
    ['minecraft:emerald_ore'] = true,
    ['minecraft:gold_ore'] = true,
    ['minecraft:iron_ore'] = true,
    ['minecraft:lapis_ore'] = true,
    ['minecraft:redstone'] = true,
    ['minecraft:redstone_ore'] = true,
    ['galacticraftcore:basic_block_core'] = true,
    ['mekanism:oreblock'] = true,
    ['appliedenergistics2:quartz_ore'] = true
}

fuelnames = {
    ['minecraft:coal'] = true,
}


-- SCREEN

monitor_side               = 'left'
monitor_max_zoom_level     = 5
default_monitor_zoom_level = 0
default_monitor_location   = {x = locations.mine_enter.x, z = locations.mine_enter.z}
