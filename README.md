# Better Mouse And Gamepad

English | [简体中文](/README_ZH.md) | [日本語](/README_JP.md)

A [*Balatro*](https://store.steampowered.com/app/2379780/Balatro/) quality of life
mod that makes the mouse and gamepad controls more efficient and easier to use,
reducing hand strain. This is possibly one of the most essential mods for any
regular *Balatro* player.

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

| Binding                     | Function                               |
| ---                         | ---                                    |
| B Button (Hold)             | same as '`Mouse 2` (Hold)'             |
| Right Joystick (Click/Hold) | same as '`Mouse 3`'/'`Mouse 3` (Hold)' |
| Left Shoulder Button        | Same as '`Mouse 4`'                    |
| Right Shoulder Button       | Same as '`Mouse 5`'                    |

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

| Steamodded version | Better-Mouse-And-Gamepad version |
| ---                | ---                              |
| v1.0.0 or newer    | [latest](https://github.com/Kooluve/Better-Mouse-And-Gamepad/releases/latest) |
| v0.9.8 or older    | v1.0.5 ([latest patch](https://github.com/Kooluve/Better-Mouse-And-Gamepad/releases/tag/v1.0.5d)) |

## Configuration

Mod configuration is split into 3 menus: **Features**, **Modifiers**, and **Gamepad**.
**Features** enables and disables the base functionality of the mod.
**Modifiers** changes the behaviour of the mouse bindings.
**Gamepad** binds gamepad buttons to the base functions
(which can still be toggled under **Functions**).

## Known Issues

Too much code is overwritten and may conflict with other mods which also modify
key mapping.

## Contributing

Pull requests are welcome!

## License

This project is licensed under the GNU General Public License. This ensures that
the software is free to use, modify, and distribute. For more details, see the
LICENSE file in the repository
