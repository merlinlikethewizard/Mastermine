-- CONTINUOUSLY BROADCAST STATUS REPORTS
while true do
    
    turtles_parked = 0
    turtle_count = 0
    for _, turtle in pairs(state.turtles) do
        if turtle.state == 'park' then
            turtles_parked = turtles_parked + 1
        end
        turtle_count = turtle_count + 1
    end

    rednet.broadcast({
            on             = state.on,
            turtles_parked = turtles_parked,
            turtle_count   = turtle_count,
        }, 'hub_report')
    
    sleep(0.5)
    
end