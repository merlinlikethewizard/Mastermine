-- CONTINUOUSLY BROADCAST STATUS REPORTS
while true do
    
    local x, y, z = gps.locate()
    
    rednet.broadcast({
            location = {x = x, y = y, z = z},
        }, 'pocket_report')
    
    sleep(0.5)
    
end