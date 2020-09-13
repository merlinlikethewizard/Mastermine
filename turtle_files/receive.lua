-- CONTINUOUSLY RECIEVE REDNET MESSAGES
while true do
    signal = {rednet.receive('mastermine')}
    if signal[2].action == 'shutdown' then
        os.shutdown()
    elseif signal[2].action == 'reboot' then
        os.reboot()
    elseif signal[2].action == 'update' then
        os.run({}, '/update')
    else
        table.insert(state.requests, signal)
    end
end