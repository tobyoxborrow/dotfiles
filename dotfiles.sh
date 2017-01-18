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
    .environments.fzf
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
    .rvmrc
    .screenrc
    .tmux.conf
    .tmux.conf.local
    .tmux.conf.solarized
    .tmux.conf.zenburn
    .vimrc
    .wgetrc
    )

mkdir -p "$backup_dir"

for dotfile in "${dotfiles[@]}"; do
    home_path="${HOME}/${dotfile}"
    repo_path="${dotfiles_dir}/${dotfile}"

    echo -n "$dotfile: "

    if [[ ! -f $repo_path ]]; then
        echo "not found in .dotfiles, skipping"
    elif [[ ! -f $home_path ]]; then
        echo "not found, creating symlink"
        ln -s "$repo_path" "$home_path"
    elif [[ -h $home_path ]]; then
        if [[ "$(readlink -f "$home_path")" == "$repo_path" ]]; then
            echo "ok"
        else
            echo "wrong symlink, overwriting"
            ln -sfT "$repo_path" "$home_path"
        fi
    elif [[ -f $home_path ]]; then
        echo "regular file, replacing with symlink"
        mv "$home_path" "$backup_dir"
        ln -s "$repo_path" "$home_path"
    else
        echo "unknown, skipping"
    fi
done
