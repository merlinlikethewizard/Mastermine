inf = 1e309


function dprint(thing)
    -- PRINT; IF TABLE PRINT EACH ITEM
    if type(thing) == 'table' then
        for k, v in pairs(thing) do
            print(tostring(k) .. ': ' .. tostring(v))
        end
    else
        print(thing)
    end
    return true
end


function str_xyz(coords, facing)
    if facing then
        return coords.x .. ',' .. coords.y .. ',' .. coords.z .. ':' .. facing
    else
        return coords.x .. ',' .. coords.y .. ',' .. coords.z
    end
end


function distance(point_1, point_2)
    return math.abs(point_1.x - point_2.x)
         + math.abs(point_1.y - point_2.y)
         + math.abs(point_1.z - point_2.z)
end


function in_area(xyz, area)
    return xyz.x <= area.max_x and xyz.x >= area.min_x and xyz.y <= area.max_y and xyz.y >= area.min_y and xyz.z <= area.max_z and xyz.z >= area.min_z
end


function in_location(xyzo, location)
    for _, axis in pairs({'x', 'y', 'z'}) do
        if location[axis] then
            if location[axis] ~= xyzo[axis] then
                return false
            end
        end
    end
    return true
end