-- CONTINUOUSLY BROADCAST STATUS REPORTS
hub_id = tonumber(fs.open('/hub_id', 'r').readAll())

while true do
    
    local x, y, z = gps.locate()
    
    rednet.send(hub_id, {
            location = {x = x, y = y, z = z},
        }, 'pocket_report')
    
    sleep(0.5)
    
end