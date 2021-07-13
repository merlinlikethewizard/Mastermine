# Mastermine
A fully automated strip mining network for ComputerCraft turtles!

Here's all the code for anyone who is interested! Check out the tutorial below for installation instructions.

Also, here are steps for a quick install via pastebin:

1. Place your advanced computer next to a disk drive with a blank disk in.
2. Run `pastebin get CtcSGkpc mastermine.lua`
3. Run `mastermine disk`
4. Run `disk/hub.lua`

## Play with or without Peripherals

I highly recommend using the a peripherals mod with chunky turtles, but upon popular request I added the ability to disable the need for chunky turtle pairs. Just go to the config and set `use_chunky_turtles = false`

## Video description:

[![https://www.youtube.com/watch?v=2I2VXl9Pg6Q](https://img.youtube.com/vi/2I2VXl9Pg6Q/0.jpg)](https://www.youtube.com/watch?v=2I2VXl9Pg6Q)

## Video tutorial:

[![https://www.youtube.com/watch?v=2DTP1LXuiCg](https://img.youtube.com/vi/2DTP1LXuiCg/0.jpg)](https://www.youtube.com/watch?v=2DTP1LXuiCg)

## Troubleshooting:

After having some chats with folks it seems like there are some common pitfalls within the turtle setup. If you're getting weird behavior I suggest taking a look at this list before posting an issue. Otherwise, please let me know your problem and we can take a look together.

* ***GPS has an incorrect coordinate.*** There are 4 computers in the GPS setup, each with an x, y, and z coordinate. If any of these numbers are entered wrong the GPS will act funky and nothing will work. A good way to test it's working is to enter `gps locate` into any rednet enabled computer or turtle and verify the answer.
* ***Mine entrance has an incorrect y value.*** Similarly, the position of `mine_entrance` is essential, and must have the correct y value of the block directly above the ground (same as the disk drive in the videos). If the y value is off, I don't quite know what will happen.
* ***Turtles are more than 8 blocks away from the mine entrance.*** Turtles have to be within the `control room area` when they are above ground, otherwise they will get lost and end up in `halt` mode. So if your disk drive is 9 or more blocks away from the entrance, the turtles will just sit there not doing anything after you initialize them. The `control_room_area` field in the `hub_files/config.lua` file is adjustable to fit whatever size you need. **Note:** If you have a large number of turtles you may need to increase the control room area to fit a larger turtle parking area.
* ***Your downloaded program is not up to date.*** Some things, such as compatibility with the new Advanced Peripherals mod, are newer additions and might not exist in the older code. I apologize that there aren't version numbers, I maybe should have a whole releases section but I haven't gotten that far yet. I wasn't expecting such a need for updates. Anyways, you might want to re-download the program periodically, just remember to preserve your config file somehow.

Hopefully that covers a lot of it. Again, lemme know if you still can't get the thing to work.

## User commands:

* `on/go`
* `off/stop`
* `turtle <#> <action>`
* `update <#>`
* `reboot <#>`
* `shutdown <#>`
* `reset <#>`
* `clear <#>`
* `halt <#>`
* `return <#>`
* `hubupdate`
* `hubreboot`
* `hubshutdown`


use `*` as notation for all turtles


## Required mods:

CC Tweaked
https://www.curseforge.com/minecraft/mc-mods/cc-tweaked

### For Minecraft 1.16:

Advanced Peripherals
https://www.curseforge.com/minecraft/mc-mods/advanced-peripherals

### For Minecraft 1.12:

Peripherals Plus One
https://github.com/rolandoislas/PeripheralsPlusOne

Required by PeripheralsPlusOne: https://www.curseforge.com/minecraft/mc-mods/the-framework
