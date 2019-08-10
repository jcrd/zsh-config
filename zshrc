#!/bin/zsh

export ZSH_CONFIG_DIR=~/.config/zsh
export ZSH_LIB_DIR=$ZSH_CONFIG_DIR/lib

source $ZSH_LIB_DIR/common.zsh

cond-source() {
    for f in $@; do
        [[ -e "$f" ]] && { source "$f"; break }
    done
}

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt bang_hist
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt share_history

# word style
autoload -Uz select-word-style
select-word-style bash

# expansion
setopt equals

# dirs
setopt auto_cd

# completion
setopt always_to_end
setopt auto_param_keys
setopt auto_param_slash
setopt auto_remove_slash
setopt complete_aliases
setopt complete_in_word
setopt glob_complete
# insert first match on ambiguous completion
# setopt menu_complete

autoload -Uz compinit
compinit -i

zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true
# select entries in completion menu
zstyle ':completion:*' menu select
# case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# prompt
setopt prompt_subst

autoload -Uz colors && colors
autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr "%F{red}*%f"
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}+%f"
zstyle ':vcs_info:git:*' formats ":%F{green}%b%f%c%u"

add-zsh-hook precmd vcs_info

_ssh_hostname() { [ -n "$SSH_CONNECTION" ] && echo '%B%m%b:' || echo '' }

function zle-line-init zle-keymap-select {
    local vi_prompt="${${KEYMAP/vicmd/|}/(main|viins)/}"
    PROMPT="[%F{blue}$(_ssh_hostname)%~%f$vcs_info_msg_0_]
%(!.#.>)${vi_prompt:- }"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

_error_symbol() { [ "$TERM" = linux ] && echo '' || echo '↲' }

RPROMPT="%(?..%F{red}%? $(_error_symbol)%f)"

# title
autoload -Uz add-zsh-hook

if [[ -n "$DISPLAY" ]]; then
    add-zsh-hook precmd (){ print -Pn '\e]2;%n@%M:%~\a' }
fi

# keybinds
export KEYTIMEOUT=1

bindkey -v

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^U' kill-whole-line
bindkey '^W' backward-kill-word

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end

self-insert-no-autoremove() { LBUFFER="$LBUFFER$KEYS" }

zle -N self-insert-no-autoremove
bindkey '|' self-insert-no-autoremove

autoload -Uz edit-command-line
zle -N edit-command-line

bindkey '^E' edit-command-line

# located in /usr/share/fzf/shell on fedora
cond-source /usr/share/fzf/{,shell/}key-bindings.zsh

# make fpath unique
typeset -U fpath
fpath=(
    ~/.config/zsh/funcs
    $fpath
)

# load functions
for f in $ZSH_CONFIG_DIR/funcs/*(N:t); do
    autoload "$f"
done

# load aliases
for f in $ZSH_CONFIG_DIR/aliases/*(N); do
    read-alias-file "$f"
done

plugins=(
    fast-syntax-highlighting.plugin.zsh
)

declare -A FAST_HIGHLIGHT_STYLES

FAST_HIGHLIGHT_STYLES[unknown-token]='fg=red'
FAST_HIGHLIGHT_STYLES[single-hyphen-option]='none'
FAST_HIGHLIGHT_STYLES[double-hyphen-option]='none'
FAST_HIGHLIGHT_STYLES[path]='fg=none,underline'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=blue,underline'
FAST_HIGHLIGHT_STYLES[subtle-bg]='underline'

# load plugins
for f in "${plugins[@]}"; do
    cond-source $ZSH_CONFIG_DIR/plugins/"${f%%.*}"/"$f"
done
unset f

# disable fsh whatis chroma
# see https://github.com/zdharma/fast-syntax-highlighting/issues/135
export FAST_HIGHLIGHT[whatis_chroma_type]=0

# recompile
autoload -Uz zrecompile
# compile into ~/.zcompdump.zwc if newer
zrecompile -p -M ~/.zcompdump

# servers
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]] && command -v tmux > /dev/null; then
    tmux new-session -A -s ssh
fi
