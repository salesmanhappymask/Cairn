# Cairn

Current release: v7

This release uses only the ComputerCraft bundled redstone API.

There are no peripheral calls and no Redstone in Motion peripheral discovery.

The ComputerCraft 1.63 jar used by this installation contains:

redstone.setBundledOutput(side, value)
redstone.getBundledOutput(side)
redstone.getBundledInput(side)
redstone.testBundledInput(side, mask)

## Wiring

Bundled RedNet cable leaves the back of the computer.

White = Up
Orange = Forward / North
Magenta = Right / East
Light Blue = Left / West
Yellow = Back / South
Lime = Down

## First test

Before running the full locomotion route, run:

drive_test

The program prints before it accesses redstone.

Choose a color and press Enter. It will energize only that bundled channel.

If the carriage moves, the computer may reboot immediately.

If no movement/reboot occurs, the program waits three seconds, clears the channel, and reports that no reboot occurred.

## Full route

Run:

locomotion_test

Route:

Up 5
Forward 5
Backward 10
Forward 5
Left 5
Right 10
Left 5
Down 5

Total: 50 one-block moves.

Run:

locomotion_test reset

to clear saved progress.

## Updating

Upload:

update
startup
drive_test
locomotion_test
README.md

Then run:

update

The updater should report release v7.
