# Cairn

Current release: v4

Files:

- update
- startup
- locomotion_test
- cairn_probe
- README.md

The updater has no manifest. Every managed program contains the Cairn release number. The updater verifies that every downloaded program belongs to the same release before deleting or replacing the installed files.

If GitHub serves a mixture of old and new files, the update aborts and tells you which file is stale.

Run:

update

You should see:

CAIRN updater
Installed release: v...
Downloaded updater release: v4
Applying CAIRN release v4
All release files verified as v4
CAIRN update complete
Installed release: v4

For diagnostics run:

cairn_probe

It does not move the carriage. It prints the installed release, program files, direct peripherals, network peripheral names, peripheral types, and methods.

For the movement test run:

locomotion_test

or:

locomotion_test north
locomotion_test south
locomotion_test east
locomotion_test west

The movement test now identifies itself as release v4 immediately when it starts.

Sequence:

Up 5
Forward 5
Backward 10
Forward 5
Left 5
Right 10
Left 5
Down 5

Reset saved progress with:

locomotion_test reset
