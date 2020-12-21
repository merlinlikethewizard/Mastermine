inf = basics.inf
str_xyz = basics.str_xyz


reverse_shift = {
    north = 'south',
    south = 'north',
    east  = 'west',
    west  = 'east',
}


function load_mine()
    -- LOAD MINE INTO state.mine FROM /mine/<x,z>/ DIRECTORY
    state.mine_dir_path = '/mine/' .. config.locations.mine_enter.x .. ',' .. config.locations.mine_enter.z .. '/'
    state.mine = {}
    
    if not fs.exists(state.mine_dir_path) then
        fs.makeDir(state.mine_dir_path)
    end
    
    if fs.exists(state.mine_dir_path .. 'on') then
        state.on = true
    end
    
    for _, level_and_chance in pairs(config.mine_levels) do
        local level = level_and_chance.level
        state.mine[level] = {y = level}
    
        -- START WITH AT LEAST A MAIN SHAFT
        state.mine[level].main_shaft = {}
        state.mine[level].main_shaft.west = {name = 'main_shaft', x = config.locations.mine_enter.x, y = level, z = config.locations.mine_enter.z, orientation = 'west'}
        state.mine[level].main_shaft.east = {name = 'main_shaft', x = config.locations.mine_enter.x, y = level, z = config.locations.mine_enter.z, orientation = 'east'}
        
        -- FOR EACH STRIP IN /mine/<x,z>/<level>/ PUT INTO MEMORY
        local level_dir_path = state.mine_dir_path .. level .. '/'
        if not fs.exists(level_dir_path) then
            fs.makeDir(level_dir_path)
        else
            for _, file_name in pairs(fs.list(level_dir_path)) do
                if file_name:sub(1, 1) ~= '.' then
                    if file_name == 'main_shaft' then
                        local xs = string.gmatch(fs.open(level_dir_path .. file_name, 'r').readAll(), '[^,]+')
                        state.mine[level].main_shaft = {}
                        state.mine[level].main_shaft.west = {name = 'main_shaft', x = tonumber(xs()), y = level, z = config.locations.mine_enter.z, orientation = 'west'}
                        state.mine[level].main_shaft.east = {name = 'main_shaft', x = tonumber(xs()), y = level, z = config.locations.mine_enter.z, orientation = 'east'}
                    else
                        local zs = string.gmatch(fs.open(level_dir_path .. file_name, 'r').readAll(), '[^,]+')
                        local x = tonumber(file_name)
                        state.mine[level][x] = {}
                        state.mine[level][x].north = {name = x, x = x, y = level, z = tonumber(zs()), orientation = 'north'}
                        state.mine[level][x].south = {name = x, x = x, y = level, z = tonumber(zs()), orientation = 'south'}
                    end
                end
            end
        end
    end
    
    state.turtles_dir_path = state.mine_dir_path .. 'turtles/'
    
    if not fs.exists(state.turtles_dir_path) then
        fs.makeDir(state.turtles_dir_path)
    end
    
    local turtle_pairs = {}
    
    for _, turtle_id in pairs(fs.list(state.turtles_dir_path)) do
        if turtle_id:sub(1, 1) ~= '.' then
            turtle_id = tonumber(turtle_id)
            local turtle = {id = turtle_id}
            state.turtles[turtle_id] = turtle
            local turtle_dir_path = state.turtles_dir_path .. turtle_id .. '/'
            if fs.exists(turtle_dir_path .. 'strip') then

                local strip_args = string.gmatch(fs.open(turtle_dir_path .. 'strip', 'r').readAll(), '[^,]+')

                local level = tonumber(strip_args())
                local name = strip_args()
                if name ~= 'main_shaft' then
                    name = tonumber(name)
                end
                local orientation = strip_args()

                if state.mine[level] and state.mine[level][name] and state.mine[level][name][orientation] then
                    turtle.strip = state.mine[level][name][orientation]
                    if fs.exists(turtle_dir_path .. 'deployed') then
                        turtle.steps_left = tonumber(fs.open(turtle_dir_path .. 'deployed', 'r').readAll())
                        if not turtle_pairs[turtle.strip] then
                            turtle_pairs[turtle.strip] = {}
                        end
                        table.insert(turtle_pairs[turtle.strip], turtle)
                    end
                end

            end
            if fs.exists(turtle_dir_path .. 'halt') then
                turtle.state = 'halt'
            end
        end
    end
    
    for strip, turtles in pairs(turtle_pairs) do
        if #turtles == 2 then
            strip.turtles = turtles
            turtles[1].pair = turtles[2]
            turtles[2].pair = turtles[1]
        end
    end
end


function write_strip(level, name)
    -- RECORD THE STATE OF A STRIP AT A GIVEN level AND name TO /mine/<center>/<level>/<name>
    local file = fs.open(state.mine_dir_path .. level .. '/' .. name, 'w')
    if name == 'main_shaft' then
        file.write(state.mine[level][name].west.x .. ',' .. state.mine[level][name].east.x)
    else
        file.write(state.mine[level][name].north.z .. ',' .. state.mine[level][name].south.z)
    end
    file.close()
end


function write_turtle_strip(turtle, strip)
    local file = fs.open(state.turtles_dir_path .. turtle.id .. '/strip', 'w')
    file.write(strip.y .. ',' .. strip.name .. ',' .. strip.orientation)
    file.close()
end


function halt(turtle)
    add_task(turtle, {action = 'pass', end_state = 'halt'})
    fs.open(state.turtles_dir_path .. turtle.id .. '/halt', 'w').close()
end


function unhalt(turtle)
    fs.delete(state.turtles_dir_path .. turtle.id .. '/halt', 'w')
end


function update_strip(turtle)
    -- RECORD THAT A STRIP HAS BEEN EXPLORED TO TURTLE'S POSITION
    local strip = turtle.strip
    if strip then
        if strip.orientation == 'north' then
            strip.z = math.min(strip.z, turtle.data.location.z)
        elseif strip.orientation == 'south' then
            strip.z = math.max(strip.z, turtle.data.location.z)
        elseif strip.orientation == 'east' then
            strip.x = math.max(strip.x, turtle.data.location.x)
        elseif strip.orientation == 'west' then
            strip.x = math.min(strip.x, turtle.data.location.x)
        end
        write_strip(strip.y, strip.name)
    end
end


function expand_mine(level, x)
    if not state.mine[level][x] then
        state.mine[level][x] = {}
        state.mine[level][x].north = {name = x, x = x, y = level, z = config.locations.mine_enter.z, orientation = 'north'}
        state.mine[level][x].south = {name = x, x = x, y = level, z = config.locations.mine_enter.z, orientation = 'south'}
        write_strip(level, x)
    end
end


function gen_next_strip()
    local level = get_mining_level()
    state.next_strip = get_closest_free_strip(level)
    if state.next_strip then
        state.min_fuel = (basics.distance(state.next_strip, config.locations.mine_enter) + config.mission_length) * 3
    else
        state.min_fuel = nil
    end
end


function get_closest_free_strip(level)
    local west_x = config.locations.mine_enter.x
    local east_x = config.locations.mine_enter.x
    local offset_x = 0
    local min_x = state.mine[level].main_shaft.west.x
    local max_x = state.mine[level].main_shaft.east.x
    
    local closest_strip
    local distance
    local z_distance
    local min_dist = inf
    
    while west_x >= min_x and east_x <= max_x and offset_x < min_dist do
        for _, x in pairs({west_x, east_x}) do
            for _, z_side in pairs({'north', 'south'}) do
                expand_mine(level, x)
                strip = state.mine[level][x][z_side]
                if not strip.turtles then
                    z_distance = math.abs(strip.z - config.locations.mine_enter.z)
                    distance = z_distance + math.abs(strip.x - config.locations.mine_enter.x)
                    if distance < min_dist then
                        min_dist = distance
                        closest_strip = strip
                    end
                end
            end
        end
        offset_x = offset_x + config.grid_width
        west_x = config.locations.mine_enter.x - offset_x
        east_x = config.locations.mine_enter.x + offset_x
    end
    
    for _, strip in pairs({state.mine[level].main_shaft.west, state.mine[level].main_shaft.east}) do
        if not strip.turtles then
            distance = math.abs(strip.x - config.locations.mine_enter.x)
            if distance <= min_dist then
                min_dist = distance
                closest_strip = strip
            end
        end
    end
    
    return closest_strip
end


function get_mining_level()
    local n = 0
    local r = math.random()
    for _, level_and_chance in pairs(config.mine_levels) do
        n = n + level_and_chance.chance
        if n > r then
            return level_and_chance.level
        end
    end
end


function good_on_fuel(mining_turtle, chunky_turtle)
    local fuel_needed = math.ceil(basics.distance(mining_turtle.data.location, config.locations.mine_exit) * 1.5)
    return (mining_turtle.data.fuel_level == "unlimited" or mining_turtle.data.fuel_level > fuel_needed) and (chunky_turtle.data.fuel_level == "unlimited" or chunky_turtle.data.fuel_level > fuel_needed)
end


function follow(chunky_turtle)
    add_task(chunky_turtle, {
        action = 'go_to_strip',
        data = {chunky_turtle.strip},
        end_state = 'wait',
    })
end


function go_mine(mining_turtle)
    update_strip(mining_turtle)
    add_task(mining_turtle, {
        action = 'mine_vein',
        data = {mining_turtle.strip.orientation},
    })
    add_task(mining_turtle, {
        action = 'clear_gravity_blocks',
    })
    add_task(mining_turtle, {
        action = 'go_to_strip',
        data = {mining_turtle.strip},
        end_state = 'wait',
        end_function = follow,
        end_function_args = {mining_turtle.pair},
    })
    mining_turtle.steps_left = mining_turtle.steps_left - 1
    local file = fs.open(state.turtles_dir_path .. mining_turtle.id .. '/deployed', 'w')
    file.write(mining_turtle.steps_left)
    file.close()
end


function free_turtle(turtle)
    if turtle.pair then
        fs.delete(state.turtles_dir_path .. turtle.id .. '/deployed')
        fs.delete(state.turtles_dir_path .. turtle.pair.id .. '/deployed')
        turtle.pair.pair = nil
        turtle.pair = nil
        turtle.strip.turtles = nil
    end
end


function pair_turtles_finish()
    state.pair_hold = nil
end


function pair_turtles_send(chunky_turtle)
    add_task(chunky_turtle, {
        action = 'go_to_mine_enter',
        end_function = pair_turtles_finish
    })
    
    add_task(chunky_turtle, {
        action = 'go_to_strip',
        data = {chunky_turtle.strip},
        end_state = 'wait',
    })
end


function pair_turtles_begin(turtle1, turtle2)
    local mining_turtle
    local chunky_turtle
    if turtle1.data.turtle_type == 'mining' then
        if turtle2.data.turtle_type ~= 'chunky' then
            error('Incompatable turtles')
        end
        mining_turtle = turtle1
        chunky_turtle = turtle2
    elseif turtle1.data.turtle_type == 'chunky' then
        if turtle2.data.turtle_type ~= 'mining' then
            error('Incompatable turtles')
        end
        chunky_turtle = turtle1
        mining_turtle = turtle2
    end
    
    local strip = state.next_strip
    local level = strip.level
    
    if not strip then
        gen_next_strip()
        add_task(turtle, {action = 'pass', end_state = 'idle'})
        add_task(turtle, {action = 'pass', end_state = 'idle'})
        return
    end
    
    print('Pairing ' .. mining_turtle.id .. ' and ' .. chunky_turtle.id)
    
    mining_turtle.pair = chunky_turtle
    chunky_turtle.pair = mining_turtle
    
    state.pair_hold = {mining_turtle, chunky_turtle}
        
    mining_turtle.steps_left = config.mission_length
    
    strip.turtles = {mining_turtle, chunky_turtle}
    
    for _, turtle in pairs(strip.turtles) do
        turtle.strip = strip
        write_turtle_strip(turtle, strip)
        add_task(turtle, {action = 'pass', end_state = 'trip'})
    end
    
    fs.open(state.turtles_dir_path .. chunky_turtle.id .. '/deployed', 'w').close()
    local file = fs.open(state.turtles_dir_path .. mining_turtle.id .. '/deployed', 'w')
    file.write(mining_turtle.steps_left)
    file.close()
    
    add_task(mining_turtle, {
        action = 'go_to_mine_enter',
        end_function = pair_turtles_send,
        end_function_args = {chunky_turtle}
    })
    
    add_task(mining_turtle, {
        action = 'go_to_strip',
        data = {mining_turtle.strip},
        end_state = 'wait',
    })
    
    gen_next_strip()
end


function check_pair_fuel(turtle)
    if state.min_fuel then
        if (turtle.data.fuel_level ~= "unlimited" and turtle.data.fuel_level <= state.min_fuel) then
            add_task(turtle, {action = 'prepare', data = {state.min_fuel}})
        else
            add_task(turtle, {action = 'pass', end_state = 'pair'})
        end
    else
        gen_next_strip()
    end
end


function send_turtle_up(turtle)
    if turtle.data.location.y < config.locations.mine_enter.y then
        if turtle.strip then
            
            if turtle.data.turtle_type == 'chunky' and turtle.data.location.y == turtle.strip.y then
                add_task(turtle, {action = 'delay', data={3}})
            end
            
            add_task(turtle, {action = 'go_to_mine_exit', data = {turtle.strip}})
        end
    end
end


function initialize_turtle(turtle)
    local data = {session_id, config}
    
    if turtle.state ~= 'halt' then
        turtle.state = 'lost'
    end
    turtle.task_id = 2
    turtle.tasks = {}
    add_task(turtle, {action = 'initialize', data = data})
end


function add_task(turtle, task)
    if not task.data then
        task.data = {}
    end
    table.insert(turtle.tasks, task)
end


function send_tasks(turtle)
    local task = turtle.tasks[1]
    if task then
        local turtle_data = turtle.data
        if turtle_data.request_id == turtle.task_id and turtle.data.session_id == session_id then
            if turtle_data.success then
                if task.end_state then
                    if turtle.state == 'halt' and task.end_state ~= 'halt' then
                        unhalt(turtle)
                    end
                    turtle.state = task.end_state
                end
                if task.end_function then
                    if task.end_function_args then
                        task.end_function(unpack(task.end_function_args))
                    else
                        task.end_function()
                    end
                end
                table.remove(turtle.tasks, 1)
            end
            turtle.task_id = turtle.task_id + 1
        elseif (not turtle_data.busy) and ((not task.epoch) or (task.epoch > os.clock()) or (task.epoch + config.task_timeout < os.clock())) then
            -- ONLY SEND INSTRUCTION AFTER <config.task_timeout> SECONDS HAVE PASSED
            task.epoch = os.clock()
            print(string.format('Sending %s directive to %d', task.action, turtle.id))
            rednet.send(turtle.id, {
                action = task.action,
                data = task.data,
                request_id = turtle_data.request_id
            }, 'mastermine')
        end
    end
end


function user_input(input)
    -- PROCESS USER INPUT FROM USER_INPUT TABLE
    while #state.user_input > 0 do
        local input = table.remove(state.user_input, 1)
        local next_word = string.gmatch(input, '%S+')
        local command = next_word()
        local turtle_id_string = next_word()
        local turtle_id
        local turtles = {}
        if turtle_id_string and turtle_id_string ~= '*' then
            turtle_id = tonumber(turtle_id_string)
            if state.turtles[turtle_id] then
                turtles = {state.turtles[turtle_id]}
            end
        else
            turtles = state.turtles
        end
        if command == 'turtle' then
            -- SEND COMMAND DIRECTLY TO TURTLE
            local action = next_word()
            local data = {}
            for user_arg in next_word do
                table.insert(data, user_arg)
            end
            for _, turtle in pairs(turtles) do
                halt(turtle)
                add_task(turtle, {
                    action = action,
                    data = data,
                })
            end
        elseif command == 'clear' then
            for _, turtle in pairs(turtles) do
                turtle.tasks = {}
                add_task(turtle, {action = 'pass'})
            end
        elseif command == 'shutdown' then
            -- REBOOT TURTLE
            for _, turtle in pairs(turtles) do
                turtle.tasks = {}
                add_task(turtle, {action = 'pass'})
                rednet.send(turtle.id, {
                    action = 'shutdown',
                }, 'mastermine')
            end
        elseif command == 'reboot' then
            -- REBOOT TURTLE
            for _, turtle in pairs(turtles) do
                turtle.tasks = {}
                add_task(turtle, {action = 'pass'})
                rednet.send(turtle.id, {
                    action = 'reboot',
                }, 'mastermine')
            end
        elseif command == 'update' then
            -- FEED TURTLE DINNER
            for _, turtle in pairs(turtles) do
                turtle.tasks = {}
                add_task(turtle, {action = 'pass'})
                rednet.send(turtle.id, {
                    action = 'update',
                }, 'mastermine')
            end
        elseif command == 'return' then
            -- BRING TURTLE HOME
            for _, turtle in pairs(turtles) do
                turtle.tasks = {}
                add_task(turtle, {action = 'pass'})
                halt(turtle)
                send_turtle_up(turtle)
                add_task(turtle, {action = 'go_to_home'})
            end
        elseif command == 'halt' then
            -- HALT TURTLE(S)
            for _, turtle in pairs(turtles) do
                turtle.tasks = {}
                add_task(turtle, {action = 'pass'})
                halt(turtle)
            end
        elseif command == 'reset' then
            -- HALT TURTLE(S)
            for _, turtle in pairs(turtles) do
                turtle.tasks = {}
                add_task(turtle, {action = 'pass'})
                add_task(turtle, {action = 'pass', end_state = 'lost'})
            end
        elseif command == 'on' or command == 'go' then
            -- ACTIVATE MINING NETWORK
            if not turtle_id_string then
                for _, turtle in pairs(state.turtles) do
                    turtle.tasks = {}
                    add_task(turtle, {action = 'pass'})
                end
                state.on = true
                fs.open(state.mine_dir_path .. 'on', 'w').close()
            end
        elseif command == 'off' or command == 'stop' then
            -- STANDBY MINING NETWORK
            if not turtle_id_string then
                for _, turtle in pairs(state.turtles) do
                    turtle.tasks = {}
                    add_task(turtle, {action = 'pass'})
                    free_turtle(turtle)
                end
                state.on = nil
                fs.delete(state.mine_dir_path .. 'on')
            end
        elseif command == 'hubshutdown' then
            -- STANDBY MINING NETWORK
            if not turtle_id_string then
                os.shutdown()
            end
        elseif command == 'hubreboot' then
            -- STANDBY MINING NETWORK
            if not turtle_id_string then
                os.reboot()
            end
        elseif command == 'hubupdate' then
            -- STANDBY MINING NETWORK
            if not turtle_id_string then
                os.run({}, '/update')
            end
        elseif command == 'debug' then
            -- DEBUG
        end
    end
end


function command_turtles()
    local turtles_for_pair = {}
    
    for _, turtle in pairs(state.turtles) do
        
        if turtle.data then
        
            if turtle.data.session_id ~= session_id then
                -- BABY TURTLE NEEDS TO LEARN
                if (not turtle.tasks) or (not turtle.tasks[1]) or (not (turtle.tasks[1].action == 'initialize')) then
                    initialize_turtle(turtle)
                end
            end

            if #turtle.tasks > 0 then
                -- TURTLE IS BUSY
                send_tasks(turtle)

            elseif not turtle.data.location then
                -- TURTLE NEEDS A MAP
                add_task(turtle, {action = 'calibrate'})

            elseif turtle.state ~= 'halt' then

                if turtle.state == 'park' then
                    -- TURTLE FOUND PARKING
                    if state.on then
                        add_task(turtle, {action = 'pass', end_state = 'idle'})
                    end

                elseif not state.on and turtle.state ~= 'idle' then
                    -- TURTLE HAS TO STOP
                    add_task(turtle, {action = 'pass', end_state = 'idle'})

                elseif turtle.state == 'lost' then
                    -- TURTLE IS CONFUSED
                    if turtle.data.location.y < config.locations.mine_enter.y and turtle.pair then
                        add_task(turtle, {action = 'pass', end_state = 'trip'})
                        add_task(turtle, {
                            action = 'go_to_strip',
                            data = {turtle.strip},
                            end_state = 'wait'
                        })
                    else
                        add_task(turtle, {action = 'pass', end_state = 'idle'})
                    end

                elseif turtle.state == 'idle' then
                    -- TURTLE IS BORED
                    free_turtle(turtle)
                    if turtle.data.location.y < config.locations.mine_enter.y then
                        send_turtle_up(turtle)
                    elseif not basics.in_area(turtle.data.location, config.locations.control_room_area) then
                        halt(turtle)
                    elseif turtle.data.item_count > 0 or (turtle.data.fuel_level ~= "unlimited" and turtle.data.fuel_level < config.fuel_per_unit) then
                        add_task(turtle, {action = 'prepare', data = {config.fuel_per_unit}})
                    elseif state.on then
                        add_task(turtle, {
                            action = 'go_to_waiting_room',
                            end_function = check_pair_fuel,
                            end_function_args = {turtle},
                        })
                    else
                        add_task(turtle, {action = 'go_to_home', end_state = 'park'})
                    end

                elseif turtle.state == 'pair' then
                    -- TURTLE NEEDS A FRIEND
                    if not state.pair_hold then
                        if not turtle.pair then
                            table.insert(turtles_for_pair, turtle)
                        end
                    else
                        if not (state.pair_hold[1].pair and state.pair_hold[2].pair) then
                            state.pair_hold = nil
                        end
                    end

                elseif turtle.state == 'wait' then
                    -- TURTLE GO DO SOME WORK
                    if turtle.pair then
                        if turtle.data.turtle_type == 'mining' and turtle.pair.state == 'wait' then
                            if turtle.steps_left <= 0 or (turtle.data.empty_slot_count == 0 and turtle.pair.data.empty_slot_count == 0) or not good_on_fuel(turtle, turtle.pair) then
                                add_task(turtle, {action = 'pass', end_state = 'idle'})
                                add_task(turtle.pair, {action = 'pass', end_state = 'idle'})
                            elseif turtle.data.empty_slot_count == 0 then
                                add_task(turtle, {
                                    action = 'dump',
                                    data = {reverse_shift[turtle.strip.orientation]}
                                })
                            else
                                add_task(turtle, {action = 'pass', end_state = 'mine'})
                                add_task(turtle.pair, {action = 'pass', end_state = 'mine'})
                                go_mine(turtle)
                            end
                        end
                    else
                        add_task(turtle, {action = 'pass', end_state = 'idle'})
                    end
                elseif turtle.state == 'mine' then
                    if not turtle.pair then
                        add_task(turtle, {action = 'pass', end_state = 'idle'})
                    end
                end
            end
        end
    end
    if #turtles_for_pair == 2 then
        pair_turtles_begin(turtles_for_pair[1], turtles_for_pair[2])
    end
end


function main()
    -- INCREASE SESSION ID BY ONE
    if fs.exists('/session_id') then
        session_id = tonumber(fs.open('/session_id', 'r').readAll()) + 1
    else
        session_id = 1
    end
    local file = fs.open('/session_id', 'w')
    file.write(session_id)
    file.close()
    
    -- LOAD MINE INTO MEMORY
    load_mine()
    
    -- FIND THE CLOSEST STRIP
    gen_next_strip()
    
    local cycle = 0
    while true do
        print('Cycle: ' .. cycle)
        user_input()         -- PROCESS USER INPUT
        command_turtles()    -- COMMAND TURTLES
        sleep(0.1)           -- DELAY 0.1 SECONDS
        cycle = cycle + 1
    end
end


main()