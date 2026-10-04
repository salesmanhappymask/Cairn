# Cairn

Current release: v6

CAIRN locomotion now uses bundled redstone through MineFactory Reloaded RedNet cable rather than the Redstone in Motion ComputerCraft peripheral.

## Drive bus

The bundled cable is attached to the back of the computer.

Movement channels:

- White = Up
- Orange = Forward / North
- Magenta = Right / East
- Light Blue = Left / West
- Yellow = Back / South
- Lime = Down

Only one propulsion channel is ever energized at a time.

## Test route

Run:

locomotion_test

The test performs:

- Up 5
- Forward 5
- Backward 10
- Forward 5
- Left 5
- Right 10
- Left 5
- Down 5

Total movement: 50 blocks.

The route returns Cairn to its starting position.

Before every move, the program:

1. Clears all bundled propulsion output.
2. Saves the movement as armed.
3. Energizes exactly one bundled color.
4. Expects Redstone in Motion to move the carriage and reboot the computer.

On reboot, startup:

1. Immediately clears the bundled output on the back.
2. Marks the armed movement complete.
3. Waits one second.
4. Resumes the next step.

If no reboot occurs within three seconds, the program clears the drive output and leaves the current movement pending rather than advancing.

When all 50 movements are complete the terminal prints:

Test complete

The terminal is not cleared.

To abandon a saved test:

locomotion_test reset

## Updating

Upload these repository files:

- update
- startup
- locomotion_test
- README.md

Run:

update

The updater should report release v6 before installing.
