local src, dest = ...

fs.copy(fs.combine(src, 'pocket_files/update'), fs.combine(dest, 'update'))
file = fs.open(fs.combine(dest, 'hub_id'), 'w')
file.write(os.getComputerID())
file.close()