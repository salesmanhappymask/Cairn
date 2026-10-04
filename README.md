# Cairn

Current release: v5

This release changes locomotion to use the exact ComputerCraft API implemented by Redstone in Motion 2.3.0.0.

The uploaded mod implements these Carriage Controller methods:

- move(direction, simulation, anchoring)
- anchored_move(direction)
- check_anchored_move(direction)
- unanchored_move(direction)
- check_unanchored_move(direction)

The v5 locomotion test uses only:

- check_unanchored_move(direction)
- unanchored_move(direction)

Directions are passed as strings accepted directly by the mod:

- up
- down
- north
- south
- west
- east

Run:

update

Confirm that the updater reports release v5.

Then run:

cairn_probe

The probe should show the controller and the five methods above.

Then run:

locomotion_test

or provide the initial facing directly:

locomotion_test north
locomotion_test south
locomotion_test east
locomotion_test west

Movement sequence:

Up 5
Forward 5
Backward 10
Forward 5
Left 5
Right 10
Left 5
Down 5

Reset an interrupted test with:

locomotion_test reset
