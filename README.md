# Cairn

Initial locomotion test for the CAIRN mobile rig.

## Repository files

- `update`
- `startup`
- `locomotion_test`

There is no manifest and no separate version file.

## First installation

Upload the contents of this ZIP to:

`https://github.com/salesmanhappymask/Cairn/tree/main`

On a fresh ComputerCraft computer, manually download only the `update` program once.

After that, run:

`update`

The updater is permanently configured to:

`https://raw.githubusercontent.com/salesmanhappymask/Cairn/main/`

Each time it runs it:

1. Downloads the newest `update` program.
2. Runs that new copy.
3. Downloads and validates the current Cairn program set.
4. Deletes writable files on the computer HDD.
5. Installs the fresh files.
6. Removes temporary update files.

Files on other mounted drives such as floppy disks are not erased.

## Locomotion test

Run:

`locomotion_test`

The test asks which absolute world direction the front of Cairn faces.

You may also specify it directly:

`locomotion_test north`
`locomotion_test south`
`locomotion_test east`
`locomotion_test west`

Sequence:

- Up 5
- Forward 5
- Backward 10
- Forward 5
- Left 5
- Right 10
- Left 5
- Down 5

The test contains 50 one-block carriage movements and should finish at its starting position.

Redstone in Motion uses absolute direction values:

- 0 = down
- 1 = up
- 2 = north
- 3 = south
- 4 = west
- 5 = east

Every move is simulated before execution. The carriage controller is called unanchored so it travels with Cairn.

Because a moved ComputerCraft computer restarts, progress is written before each physical movement. `startup` waits briefly for peripherals to reconnect, rediscovers the carriage controller, and resumes the next movement.

Controller discovery checks all six directly attached faces and all peripheral names visible through wired modem networks.

When the route finishes the program prints:

`Test complete`

The terminal is not cleared by the program afterward.

If you need to abandon a saved test and begin again:

`locomotion_test reset`
