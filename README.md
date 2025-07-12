# Better Mouse And Gamepad

English | [简体中文](/README_ZH.md) | [日本語](/README_JP.md)

A [*Balatro*](https://store.steampowered.com/app/2379780/Balatro/) quality of life
mod that makes the mouse and gamepad controls more efficient and easier to use,
reducing hand strain. This is possibly one of the most essential mods for any
regular *Balatro* player.

I highly recommend using [Handy](https://github.com/SleepyG11/HandyBalatro) instead.
It was released last August and has been consistently maintained since then,
has more features, includes many shortcut operations, and allows highly customizable
key bindings, almost outperforming my mod in every way. As of July 12, 2025, the
drawbacks are: slightly cumbersome settings, and somewhat different controls (mainly
the inability to continuously select and cancel cards during a single right-click
hold, even if the option "Presets -> Pre-made presets -> Better Mouse and Gamepad"
is selected, making it less smooth than my mod).

## Controls

### Mouse
On right-handed mice, `Mouse 2` corresponds to the right mouse button.
`Mouse 3` is the middle mouse button, usually a clickable scroll wheel.
`Mouse 4` and `Mouse 5` are less common, but are usually found by the
user's thumb.

| Binding               | Function                                         |
| ---                   | ---                                              |
| `Mouse 2`             | Deselect all cards (same as the unmodified game) |
| `Mouse 2` (Hold/Drag) | Select multiple cards                            |
| `Mouse 3`             | Open menu (same as `ESC`)                        |
| `Mouse 3` (Hold)      | Start new run (same as `R`)                      |
| `Mouse Wheel Up`      | Play hand                                        |
| `Mouse Wheel Down`    | Discard cards                                    |
| `Mouse 4`             | Sort hand by suit                                |
| `Mouse 5`             | Sort hand by value                               |

### Gamepad

Gamepad bindings bind to the mouse bindings, allowing toggling via the
`Features` config menu. See [Configuration](#configuration) for more details.

| Binding                       | Function                               |
| ---                           | ---                                    |
| `B Button` (Hold)             | same as '`Mouse 2` (Hold)'             |
| `Right Joystick` (Click/Hold) | same as '`Mouse 3`'/'`Mouse 3` (Hold)' |
| `Left Shoulder Button`        | Same as '`Mouse 4`'                    |
| `Right Shoulder Button`       | Same as '`Mouse 5`'                    |

## Installation

Follow the
[installation instructions](https://github.com/Steamodded/smods/wiki)
for
[Steamodded](https://github.com/Steamodded/smods)
to install. This will at least include
[installing the Lovely injector](https://github.com/ethangreen-dev/lovely-injector?tab=readme-ov-file#manual-installation),
adding a `Mods` folder in your *Balatro* `%appdata%` folder, and adding
Steamodded to this folder. Once Steamodded is installed, download a
release of this repository
[here](https://github.com/Kooluve/Better-Mouse-And-Gamepad/releases),
and extract the archive into the `Mods` folder.

### Supported Steamodded version

| Steamodded version   | Better-Mouse-And-Gamepad version |
| ---                  | ---                              |
| `v1.0.0` or newer    | [`latest`](https://github.com/Kooluve/Better-Mouse-And-Gamepad/releases/latest) |
| `v0.9.8` or older    | `v1.0.5` ([latest patch](https://github.com/Kooluve/Better-Mouse-And-Gamepad/releases/tag/v1.0.5d)) |

## Configuration

Mod configuration is split into 3 menus: **Features**, **Modifiers**, and **Gamepad**.
**Features** enables and disables the base functionality of the mod.
**Modifiers** changes the behaviour of the mouse bindings.
**Gamepad** binds gamepad buttons to the base functions
(which can still be toggled under **Features**).

## Known Issues

Too much code is overwritten and may conflict with other mods which also modify
key mapping.

## Find More Mods

By the way, you can find more mods in these places:
[awesome-balatro](https://github.com/jie65535/awesome-balatro)
[Balatro Mod Index](https://docs.google.com/spreadsheets/d/1aoJrrC7Y-dkvJwBu_U6amelYnoCrZgWqpoGRAfHN1ys)
[discord--modding](https://discord.com/channels/1116389027176787968/1209506514763522108)
[mod wiki](https://balatromods.miraheze.org/wiki/Main_Page)
[nexus](https://www.nexusmods.com/games/balatro/mods)

## Contributing

Pull requests are welcome!

## License

This project is licensed under the GNU General Public License. This ensures that
the software is free to use, modify, and distribute. For more details, see the
LICENSE file in the repository
