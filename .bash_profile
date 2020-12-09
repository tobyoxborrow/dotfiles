#!/bin/bash

# vi mode
set -o vi

# basic prompt: "user@host dir$ "
# overridden by .bash_prompt if it exists
PS1="\u@\h \W\$ "

# Load the shell dotfiles, and then some:
for file in ~/.{path,exports,environments,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Use starship if available, otherwise fallback to my own dynamic bash prompt
if hash starship 2>/dev/null; then
    eval "$(starship init bash)"
else
	[ -r ".bash_prompt" ] && [ -f ".bash_prompt" ] && source ".bash_prompt";
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;
