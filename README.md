# Cairn

CAIRN locomotion test v2.

Repository:

https://github.com/salesmanhappymask/Cairn

## Install

Place these files in the repository root:

- update
- startup
- locomotion_test
- README.md

On a fresh ComputerCraft computer, manually install only `update`.

Then run:

update

Future updates also use:

update

## Locomotion test

Run:

locomotion_test

Or specify Cairn's forward world direction:

locomotion_test north
locomotion_test south
locomotion_test east
locomotion_test west

The program now prints immediately when it starts and catches runtime errors so failures should remain visible on the terminal.

Sequence:

Up 5
Forward 5
Backward 10
Forward 5
Left 5
Right 10
Left 5
Down 5

The program performs one carriage movement per execution. If the computer reboots because it moved with the carriage, `startup` resumes the next step. If Redstone in Motion returns normally without rebooting the computer, the program launches the next step itself.

The carriage controller is rediscovered before every movement. The program examines all six direct faces and all peripherals exposed by wired modem networks.

Each move is simulated first.

Run this to discard saved progress:

locomotion_test reset
