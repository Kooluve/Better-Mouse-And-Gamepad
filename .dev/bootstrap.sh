#!/bin/sh

# Ensure the `install_hooks` subshell return codes cascade upwards
set -e

# If no arguments provided with script call...
if 
    [ $# -eq 0 ]
then
    # ...then current directory is target directory...
    DIR="$(pwd)/.dev"
else
    # ...else set argument as target directory and cd into it.
    DIR="$(cd "$(dirname $0)" && pwd)"
fi
cd "$DIR/.." || exit 1
DIR="$(pwd)"

# Default info logging function
log() {
    printf "[\x1b[0;1;34m*\x1b[0m] %s: \x1b[0;34m%s\x1b[0m\n" "$(basename $0)" "$*"
}

# Default error logging function
e_log() {
    printf "[\x1b[0;1;31m!\x1b[0m] %s: \x1b[0;1;31m%s\x1b[0m\n" "$(basename $0)" "$*"
}

# Default success logging function
s_log() {
    printf "[\x1b[0;1;32m+\x1b[0m] %s: \x1b[0;1;32m%s\x1b[0m\n" "$(basename $0)" "$*"
}

setup_git() {
    # Set up `Signed-off-by` git trailer
    git config set trailer.sign.key "Signed-off-by: "
    git config set trailer.sign.ifmissing add
    git config set trailer.sign.ifexists doNothing
    git config set trailer.sign.cmd 'echo "$(git config user.name) <$(git config user.email)>"'

    # Set up default commit template
    git config set commit.template "$DIR/.dev/commit-template"
}

# Installs the git hooks via checking for differences between `./dev/hooks` and `./.git/hooks`
# If there are differences, the script nukes pre-existing hooks and inserts its own custom ones
install_hooks() (
    hook_src_dir="$DIR/.dev/hooks"
    hook_dest_dir="$DIR/.git/hooks"

    # If the source dir doesn't exist, the repo is missing stuff
    if
        ! test -d "$hook_src_dir"
    then
        e_log "Git hook source directory not found; re-clone this repo!"
        return 1
    fi

    if 
        [ $# -eq 0 ]
    then
        git diff --quiet "$hook_src_dir" "$hook_dest_dir" 2> /dev/null || {
            log 'Configuring git hooks...'

            # World's longest `printf` call I swear
            printf \
            "[\x1b[0;1;34m*\x1b[0m] %s: \x1b[0;34m%s\n\tfrom \x1b[0m\`%s\`\n\t\x1b[0;34minto \x1b[0m\`%s\`\x1b[0;34m...\x1b[0m\n" \
            "$(basename $0)" \
            "Installing git hooks for repository" \
            "$hook_src_dir" \
            "$hook_dest_dir"

            rm -rf "$hook_dest_dir"
            cp -r "$hook_src_dir" "$hook_dest_dir"

            s_log 'Git hooks configured successfully!'
        }
    else
        # Check for differences between the directories; copy repo files if discrepancies exist
        git diff --quiet "$1" "$2" "$hook_src_dir" 2> /dev/null || {
            log 'Configuring git hooks...'

            # World's longest `printf` call I swear
            printf \
            "[\x1b[0;1;34m*\x1b[0m] %s: \x1b[0;34m%s\n\tfrom \x1b[0m\`%s\`\n\t\x1b[0;34minto \x1b[0m\`%s\`\x1b[0;34m...\x1b[0m\n" \
            "$(basename $0)" \
            "Installing git hooks for repository" \
            "$hook_src_dir" \
            "$hook_dest_dir"

            rm -rf "$hook_dest_dir"
            cp -r "$hook_src_dir" "$hook_dest_dir"

            s_log 'Git hooks configured successfully!'
        }
    fi
)

setup_git "$@"
install_hooks "$@"
