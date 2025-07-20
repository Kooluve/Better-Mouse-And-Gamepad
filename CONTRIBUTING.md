# BMAG Contributing Guide

## Welcome

Welcome to the BMAG (Better Mouse and Gamepad) Contributing Guide, and thank you
for your interest.

## Overview

The purpose of BMAG is to extend the current *Balatro* control schema to be more
comfortable and ergonomic. It allows for binding custom buttons to a set of in-game
functions, making the controls more fluid than in the base game.

## Ground rules

Before contributing, read our
[Code of Conduct](https://github.com/uptudev/bmag/blob/main/CODE_OF_CONDUCT.md)
to learn more about our community guidelines and expectations.

## Community engagement

Refer to the following channels to connect to fellow contributors or to stay up-to-date
with news about BMAG:

* Join our project contributors on
[LiberaChat](https://libera.chat/)
at `#BMAG`.

## Share ideas

To share your new ideas for the project, perform the following actions:

1. Open a *Feature Request*
[GitHub Issue](https://github.com/uptudev/bmag/issues).
1. Wait for a maintainer to address the potential feature.
1. If the feature request is closed without being incorporated, please do not open
another one. It will be closed as a duplicate without substantial reasoning behind
reopening it.

## Before you start

Before you start contributing, ensure you have the following:

* `git`, preferably a somewhat up-to-date version with `git-hooks` support,
* a POSIX-compliant shell for the `post-checkout` script,
* a copy of *Balatro* for testing your code, and
* (optional) the *Lua* interpreter

## Environment setup

To set up your environment, perform the following actions:

* Clone the repository with either:
  * `git clone https://github.com/uptudev/bmag` (HTTPS), or
  * `git clone git@github.com:uptudev/bmag` (SSH)
* Bootstrap the `git commit` template and `git-hooks` by running `./.dev/bootstrap.sh`.
This script:
  * Sets up `git` `Signed-off-by:` trailers indicating commit author,
  * Sets `git commit` template for the repository to `./.dev/commit-template`, and
  * Copies the contents of `./.dev/hooks/` to `./.git/hooks/`.

### Troubleshoot

If you encounter issues as you set up your environment, message me through GitHub
or message the IRC group on
[LiberaChat](https://libera.chat/)
at `#BMAG`.

## Best practices

Our project uses the
[Olivine Labs Lua style guide](https://github.com/Olivine-Labs/lua-style-guide)
as our parent guide for best practices. Reference the guide to familiarize yourself
with the best practices we want contributors to follow. Exceptions may be made
as long as they are cleaned up during review.

## Contribution workflow

### Report issues and bugs

To report a bug, open a *Bug Report*
[GitHub Issue](https://github.com/uptudev/bmag/issues).
Please follow all instructions within the report template.

### Commit messages

Commit messages are automatically made compliant with
[Conventional Commits v1](https://www.conventionalcommits.org/en/v1.0.0/)
by the `commit-template` file and the `commit-msg` `git-hook`, but if this does
not work, they must be of the below format:

```text
<type>(scope): <description>

# See Conventional Commits for more info on commit header formatting
# https://www.conventionalcommits.org/

create:
+ `./foo`: add a file that does something

modify:
* `./bar`: change the contents of the file

delete:
- `./baz`: remove the file

Signed-off-by: [username] <[email]>
```

### Pull requests

Pull requests must contain massages in the following format:

```markdown
## Describe your changes

## Issue ticket number and link (if applicable)

## Checklist before requesting a review
- [ ] I have performed a self-review of my code.
- [ ] If it is a core feature, I have added thorough tests.
- [ ] Will this be part of a product update? If yes, please write one phrase
about this update below.
```

### Releases

Release naming follows [Semantic Versioning](https://semver.org/).
All releases will be created with *only*:

* `./src/`: the main mod code directory
* `./bmag.lua`: contains metadata and calls `./src/main.lua`
* `./CHANGELOG.md`: contains changes between release versions; is compliant with
[Keep A Changelog](https://keepachangelog.com/)
* `./LICENSE`: must be included with any licensed source code
* `./README.md`: user guide for the mod

All other files should not be packaged in any release archives.
Release naming convention is of the following form:
`bmag_v<VERSION>.<EXTENSION>`, for example: `bmag_v2.0.0.tar.xz` or `bmag_v2.0.0.zip`.

### Text formats

Keep all files in UTF-8 for portability. Also ensure CRLF is handled in `git`
correctly according to your platform so as to not modify source code when
pushing to the repository.
