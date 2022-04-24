#!/bin/zsh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export GOPATH=~/code/go

typeset -U path
path=(
"$HOME/.local/bin"
"$XDG_DATA_HOME/zsh/bin"
"$HOME/.luarocks/bin"
"$GOPATH/bin"
$path[@])

export VISUAL='code -w'
export EDITOR=nvim
export SUDO_EDITOR=nvim

export MAKEFLAGS="-j$(nproc)"
export ABDUCO_CMD="$SHELL"
export QT_QPA_PLATFORMTHEME=gtk2

export CHASSIS="$(hostnamectl 2> /dev/null | awk '$1 == "Chassis:" {print $2}')"


unset SSH_AGENT_PID
if [[ -n "$DESKTOP_SESSION" && $(command -v gnome-keyring-daemon) ]]; then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
elif [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
