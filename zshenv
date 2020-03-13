#!/bin/zsh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export GOPATH=~/code/go

typeset -U path
path=(
"/usr/lib/ccache/bin"
"$HOME/.local/bin"
"$HOME/.luarocks/bin"
"$GOPATH/bin"
$path[@])

export EDITOR=nvim
export SUDO_EDITOR=nvim
export BROWSER=qutebrowser

export GPG_TTY="$(tty)"
export MAKEFLAGS="-j$(nproc)"
export ABDUCO_CMD="$SHELL"
export QT_QPA_PLATFORMTHEME=gtk2
