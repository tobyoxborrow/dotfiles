#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

dotfiles_dir="${HOME}/.dotfiles"
backup_dir="${HOME}/.dotfiles_backup"
config_dir="${HOME}/.config"

mkdir -p "$backup_dir"
mkdir -p "$config_dir"

dotfiles=(
    .ackrc
    .aliases
    .aspell.conf
    .bash_profile
    .bash_prompt
    .bashrc
    .curlrc
    .environments
    .environments.bat
    .environments.golang
    .environments.homebrew
    .environments.perlbrew
    .environments.pipenv
    .environments.pyenv
    .environments.rust
    .environments.rvm
    .environments.tag
    .exports
    .functions
    .gitconfig
    .gitignore
    .inputrc
    .path
    .profile
    .rvmrc
    .screenrc
    .stCommitMsg
    .tmux.conf
    .tmux.conf.local
    .tmux.conf.theme
    .vimrc
    .wgetrc
    .config/starship.toml
    )

# Try to find GNU readlink from homebrew's coreutils package for macOS
# The readlink in macOS doesn't support some of the options I want
READLINK=""
if [[ -f /usr/local/opt/coreutils/libexec/gnubin/readlink ]]; then
    READLINK="/usr/local/opt/coreutils/libexec/gnubin/readlink"
elif which greadlink; then
    READLINK=$(which greadlink)
else
    READLINK=$(which readlink)
fi
# Is this GNU readlink?
if ! $READLINK --version 2>&1 | grep -q GNU; then
    echo "readlink is $READLINK"
    echo "GNU readlink not found"
    echo "On macOS install the coreutils package from homebrew"
    exit 1
fi

# Try to find GNU ln from homebrew's coreutils package for macOS
# The ln in macOS doesn't support some of the options I want
LN=""
if [[ -f /usr/local/opt/coreutils/libexec/gnubin/ln ]]; then
    LN="/usr/local/opt/coreutils/libexec/gnubin/ln"
elif which gln; then
    LN=$(which gln)
else
    LN=$(which ln)
fi
# Is this GNU ln?
if ! $LN --version 2>&1 | grep -q GNU; then
    echo "ln is $LN"
    echo "GNU ln not found"
    echo "On macOS install the coreutils package from homebrew"
    exit 1
fi

for dotfile in "${dotfiles[@]}"; do
    home_path="${HOME}/${dotfile}"
    repo_path="${dotfiles_dir}/${dotfile}"

    if [[ ! -f $repo_path ]]; then
        echo "${dotfile}: not found in .dotfiles, skipping"
    elif [[ ! -f $home_path ]]; then
        echo "${dotfile}: not found, creating symlink"
        $LN -s "$repo_path" "$home_path"
    elif [[ -h $home_path ]]; then
        if [[ "$($READLINK -f "$home_path")" != "$repo_path" ]]; then
            echo "${dotfile}: wrong symlink, overwriting"
            $LN -sfT "$repo_path" "$home_path"
        fi
    elif [[ -f $home_path ]]; then
        echo "${dotfile}: regular file, replacing with symlink"
        mv "$home_path" "$backup_dir"
        $LN -s "$repo_path" "$home_path"
    else
        echo "${dotfile}: unknown, skipping"
    fi
done
