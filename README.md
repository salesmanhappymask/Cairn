# Cairn

Current repository release: v3

## Update system

The repository does not use a manifest.

The release number is embedded directly in the `update` program.

On every update, the computer prints:

- the currently installed Cairn release
- the release number of the updater downloaded from GitHub
- the release being applied
- the final installed release

The installed release is stored locally in:

`.cairn_version`

GitHub downloads include a changing cache-busting query so repeated update attempts are less likely to receive an older cached raw file.

If GitHub is still propagating a change, running `update` again will clearly show which updater release was actually downloaded.

## Fresh installation

Manually place only `update` on a new ComputerCraft computer.

Run:

`update`

After that, all future updates also use:

`update`

## Locomotion test

Run:

`locomotion_test`

or:

`locomotion_test north`
`locomotion_test south`
`locomotion_test east`
`locomotion_test west`

Reset saved test progress with:

`locomotion_test reset`
