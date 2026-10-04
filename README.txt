CAIRN Locomotion Test v1

Files:
startup
locomotion_test.lua
update.lua
manifest.txt

Installation:
1. Copy startup, locomotion_test.lua, and update.lua to the ComputerCraft computer.
2. The carriage controller and computer must both be part of the moving carriage.
3. Run:
   locomotion_test
4. Enter the world direction that represents Cairn's forward direction.

You may also specify it directly:
locomotion_test north
locomotion_test south
locomotion_test east
locomotion_test west

The test performs:
Up 5
Forward 5
Backward 10
Forward 5
Left 5
Right 10
Left 5
Down 5

It uses Redstone in Motion's absolute direction API:
0 down
1 up
2 north
3 south
4 west
5 east

The controller is called with:
move(direction, false, false)

The final false means the controller moves with the carriage.

The program scans all six computer faces and all peripheral names exposed by peripheral.getNames(), so a wired-network carriage controller does not need a permanent side or network name.

Updater:
Put manifest.txt, startup, locomotion_test.lua, and update.lua at the root of the new repository.

On the first update, run:
update https://raw.githubusercontent.com/USERNAME/REPOSITORY/main

The URL is saved locally. Later updates only require:
update

The updater downloads and validates the full release before replacing the installed files.
