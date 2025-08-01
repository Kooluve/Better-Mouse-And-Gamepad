# Better Mouse and Gamepad

A [*Balatro*](https://store.steampowered.com/app/2379780/Balatro/) quality of life
mod that allows binding any key or button to a variety of quick functions,
reducing hand strain. This is possibly one of the most essential mods for any
regular *Balatro* player, allowing:

* Multiselect: hold a key to select all cards your cursor passes over,
* Deselect: deselect any selected cards,
* Sort (by suit or value): rearrange all cards in your hand,
* Play: play selected cards
* Discard: discard selected cards
* Restart: restart, keeping the current run settings

## Configuration

To set up bindings, go to the Mods menu, then click 'Better Mouse and Gamepad',
then 'Config'.

In this menu, clicking on any of the features will cause the game to listen for
the next click or hold event, then bind the key to the feature.

Default configuration is as follows:

| Feature | Key |
| --- | --- |
| Multiselect | `Mouse2 (Hold)` |
| Deselect | `Mouse2 (Click)` |
| Sort by suit | `Mouse Wheel Up` |
| Sort by value | `Mouse Wheel Down` |
| Play | `Mouse5 (Click)` |
| Discard | `Mouse4 (Click)` |
| Restart | [Unbound by default] |

## Installation

Follow the
[installation instructions](https://github.com/Steamodded/smods/wiki)
for
[Steamodded](https://github.com/Steamodded/smods)
to install. This will at least include
[installing the Lovely injector](https://github.com/ethangreen-dev/lovely-injector?tab=readme-ov-file#manual-installation),
adding a `Mods` folder in your *Balatro* `%appdata%` folder, and adding
Steamodded to this folder. Once Steamodded is installed, download a release of
this repository
[here](https://github.com/uptudev/bmag/releases), and extract the source code
archive into the `Mods` folder.

Your Steamodded version should be at minimum **v1.0.0**.

## Known Issues

This mod might not be compatible with any others that override the Love2D
press/release event hooks.

Sometimes attempting to bind a key will not work for an unknown reason. If this
happens, try to bind it to another feature and try again.

## Find More Mods

You can find more mods here:

* [awesome-balatro](https://github.com/jie65535/awesome-balatro)
* [Balatro Mod Index](https://docs.google.com/spreadsheets/d/1aoJrrC7Y-dkvJwBu_U6amelYnoCrZgWqpoGRAfHN1ys)
* [discord--modding](https://discord.com/channels/1116389027176787968/1209506514763522108)
* [mod wiki](https://balatromods.miraheze.org/wiki/Main_Page)
* [nexus](https://www.nexusmods.com/games/balatro/mods)

## Contributing

Please review our [CONTIBUTING](/CONTIBUTING.md) file before attempting to contribute
in any fashion. All contributions must align with both the guidelines there and
those in the [Code of Conduct](/CODE_OF_CONDUCT.md).

## License

This project in its entirety is licensed under [the MIT/X11 license](/LICENSE).
Versions of this mod before `v2.0.0` were licensed under the GPLv3 license, but
the entire project was rewritten from scratch with the intent to re-license it under
a more suitable copyleft license.
