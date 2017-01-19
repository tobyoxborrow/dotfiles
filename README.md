# dotfiles

Repository for dotfiles and only dotfiles. No software installation or
provisioning to be found here. This repository is indended to be kept minimal
so it can more freely be used on pretty much any host.

Some of the files originally came from [Mathias's
dotfiles](https://github.com/mathiasbynens/dotfiles) when I used a fork of that
for my dotfiles.

## Usage

Includes `dotfiles.sh` to take care of creating symlinks in ~ to `~/.dotfiles`.
If there are existing files, they will be moved to `~/.dotfiles_backup`.

```
git clone https://github.com/tobyoxborrow/dotfiles ~/.dotfiles/ && bash ~/.dotfiles/dotfiles.sh
```
