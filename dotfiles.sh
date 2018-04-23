#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

backup_dir="${HOME}/.dotfiles_backup"
dotfiles_dir="${HOME}/.dotfiles"

dotfiles=(
    .ackrc
    .aliases
    .aspell.conf
    .bash_profile
    .bash_prompt
    .bashrc
    .curlrc
    .environments
    .environments.golang
    .environments.homebrew
    .environments.perlbrew
    .environments.pyenv
    .environments.rvm
    .exports
    .functions
    .gitconfig
    .gitignore
    .inputrc
    .path
    .profile
    .rvmrc
    .screenrc
    .tmux.conf
    .tmux.conf.local
    .tmux.conf.theme
    .vimrc
    .wgetrc
    )

mkdir -p "$backup_dir"

for dotfile in "${dotfiles[@]}"; do
    home_path="${HOME}/${dotfile}"
    repo_path="${dotfiles_dir}/${dotfile}"

    if [[ ! -f $repo_path ]]; then
        echo "${dotfile}: not found in .dotfiles, skipping"
    elif [[ ! -f $home_path ]]; then
        echo "${dotfile}: not found, creating symlink"
        ln -s "$repo_path" "$home_path"
    elif [[ -h $home_path ]]; then
        if [[ "$(readlink -f "$home_path")" != "$repo_path" ]]; then
            echo "${dotfile}: wrong symlink, overwriting"
            ln -sfT "$repo_path" "$home_path"
        fi
    elif [[ -f $home_path ]]; then
        echo "${dotfile}: regular file, replacing with symlink"
        mv "$home_path" "$backup_dir"
        ln -s "$repo_path" "$home_path"
    else
        echo "${dotfile}: unknown, skipping"
    fi
done
