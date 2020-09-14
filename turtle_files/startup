-- SET LABEL
os.setComputerLabel('Turtle ' .. os.getComputerID())

-- INITIALIZE APIS
if fs.exists('/apis') then
    fs.delete('/apis')
end
fs.makeDir('/apis')
fs.copy('/config.lua', '/apis/config')
fs.copy('/state.lua', '/apis/state')
fs.copy('/basics.lua', '/apis/basics')
fs.copy('/actions.lua', '/apis/actions')
os.loadAPI('/apis/config')
os.loadAPI('/apis/state')
os.loadAPI('/apis/basics')
os.loadAPI('/apis/actions')


-- OPEN REDNET
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end


-- IF UPDATED PRINT "UPDATED"
if fs.exists('/updated') then
    fs.delete('/updated')
    print('UPDATED')
    state.updated_not_home = true
end


-- LAUNCH PROGRAMS AS SEPARATE THREADS
multishell.launch({}, '/report.lua')
multishell.launch({}, '/receive.lua')
multishell.launch({}, '/mastermine.lua')
multishell.setTitle(2, 'report')
multishell.setTitle(3, 'receive')
multishell.setTitle(4, 'mastermine')