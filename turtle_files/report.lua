-- CONTINUOUSLY BROADCAST STATUS REPORTS
hub_id = tonumber(fs.open('/hub_id', 'r').readAll())

while true do

    state.item_count = 0
    state.empty_slot_count = 16
    for slot = 1, 16 do
        slot_item_count = turtle.getItemCount(slot)
        if slot_item_count > 0 then
            state.empty_slot_count = state.empty_slot_count - 1
            state.item_count = state.item_count + slot_item_count
        end
    end
    
    rednet.send(hub_id, {
            session_id       = state.session_id,
            request_id       = state.request_id,
            turtle_type      = state.type,
            peripheral_left  = state.peripheral_left,
            peripheral_right = state.peripheral_right,
            updated_not_home = state.updated_not_home,
            location         = state.location,
            orientation      = state.orientation,
            fuel_level       = turtle.getFuelLevel(),
            item_count       = state.item_count,
            empty_slot_count = state.empty_slot_count,
            distance         = state.distance,
            strip            = state.strip,
            success          = state.success,
            busy             = state.busy,
        }, 'turtle_report')
    
    sleep(0.5)
    
end