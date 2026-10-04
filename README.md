# Cairn

Current release: v8

Cairn locomotion now uses ordinary ComputerCraft analog redstone output.

No bundled-redstone API is used.
No Redstone in Motion peripheral API is used.
No peripheral discovery is used.

The computer outputs a redstone strength from its back.
A MineFactory Reloaded Programmable RedNet Controller translates that strength into a RedNet color.

## Command bus

0 = Off
1 = Up
2 = Forward / North
3 = Right / East
4 = Left / West
5 = Back / South
6 = Down

The PRC should translate these commands to:

1 -> White
2 -> Orange
3 -> Magenta
4 -> Light Blue
5 -> Yellow
6 -> Lime

## PRC setup

Feed the computer's back-side ordinary redstone output into the PRC.

Configure six PRC circuits so each circuit tests the incoming redstone strength for one exact value and outputs a full-strength RedNet signal on the matching color.

Circuit 1:
Input equals 1
Output White

Circuit 2:
Input equals 2
Output Orange

Circuit 3:
Input equals 3
Output Magenta

Circuit 4:
Input equals 4
Output Light Blue

Circuit 5:
Input equals 5
Output Yellow

Circuit 6:
Input equals 6
Output Lime

The PRC's RedNet side then connects to the colored RedNet network around the carriage engines.

## First test

Run:

drive_test

Choose one of:

up
forward
right
left
back
down
off

The program prints the selected signal strength and waits for Enter before energizing it.

Use a redstone lamp or redstone-strength indicator on the computer output while testing if desired.

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

To abandon a stored test:

locomotion_test reset

## Updating

Upload:

update
startup
drive_test
locomotion_test
README.md

Then run:

update

The updater should report release v8.
