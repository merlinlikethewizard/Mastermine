-- SET LABEL
os.setComputerLabel('pocket ' .. os.getComputerID())


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
end


-- LAUNCH PROGRAMS AS SEPARATE THREADS
multishell.launch({}, '/user.lua')
multishell.launch({}, '/info.lua')
multishell.launch({}, '/report.lua')
multishell.setTitle(2, 'usr')
multishell.setTitle(3, 'info')
multishell.setTitle(4, 'rep')