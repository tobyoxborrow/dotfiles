#!/usr/bin/env bash
# Instantly jump to your ag or ripgrep matches
# https://github.com/aykamko/tag
if hash rg 2>/dev/null; then
    export TAG_SEARCH_PROG=rg
    tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null; }
    alias rg=tag  # replace with rg for ripgrep
fi
