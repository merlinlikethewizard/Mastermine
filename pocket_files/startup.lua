-- SET LABEL
os.setComputerLabel('pocket ' .. os.getComputerID())


-- OPEN REDNET
rednet.open('back')


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