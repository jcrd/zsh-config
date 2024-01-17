#!/bin/zsh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export GOPATH=~/go

typeset -U path
path=(
"$HOME/.local/bin"
"$HOME/.luarocks/bin"
"$HOME/.flutter/bin"
"$HOME/.pub-cache/bin"
"$GOPATH/bin"
$path[@])

export VISUAL='code -w'
export EDITOR=vi
export SUDO_EDITOR=vi

export MAKEFLAGS="-j$(nproc)"
export ABDUCO_CMD="$SHELL"
export QT_QPA_PLATFORMTHEME=gtk2

export CHASSIS="$(hostnamectl 2> /dev/null | awk '$1 == "Chassis:" {print $2}')"

export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
