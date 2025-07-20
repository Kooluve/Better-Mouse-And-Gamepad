# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `.gitignore`: Set up to ignore my notes (because they keep getting tracked).
- `bmag.json`: The mod metadata.
- `CHANGELOG.md`: This repository should have a changelog (this file).
- `src/`: All source code has moved here except localization. If there was a way
to get Steamodded to point to a custom directory, it would be in here too.
  - `src/libs/`: Handwritten Lua libraries put in here so as to not pollute the
  main Lua file.
    - `src/libs/queue.lua`: A FIFO queue implementation
    - `src/libs/timers.lua`: A timer table implementation
  - `src/main.lua`: The main entry point for the mod. Loaded by `./bmag.lua` immediately.

### Changed

- Rewrite of all mod code from scratch, moving it into a proper directory structure.
- `LICENSE`: Replacement of the GPLv3 license with the MIT/X11 license. This is
mainly due to unnecessary restrictions in the GPLv3 license which do not fit the
project, including the restriction against bundling with proprietary code, which
the base game of Balatro might include.

### Removed

- All old code that falls under GPLv3, including:
  - `BetterMouseAndGamepad.lua`,
  - `config.lua`,
  - `localization/en-us.lua`,
  - `localization/ja.lua`,
  - `localization/zh_CN.lua`,
  - `README_JP.md`,
  - `README_ZH.md`,

  The base `README.md` stays for now, largely because documentation does not fall
  under GPLv3 restrictions and because I am the author of the file anyways.
