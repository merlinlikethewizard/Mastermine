-- CONTINUOUSLY AWAIT USER INPUT AND PLACE IN TABLE
while true do
    rednet.broadcast(read(), 'user_input')
end