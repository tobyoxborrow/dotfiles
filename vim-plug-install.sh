#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

COMMIT_HASH=88e31471818e9a29a8a20a0ee61360cfd7bdc1cd
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/${COMMIT_HASH}/plug.vim"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs "$PLUG_URL"

echo Start vim and call :PlugInstall
