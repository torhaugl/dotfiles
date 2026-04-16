# GENERAL ENVIRONMENT
# Bash history
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# fuzzyfinder fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# GENERAL ALIASES
alias ls='ls --group-directories-first --color'
alias sl='ls --group-directories-first --color'
alias ll='ls -lFh --group-directories-first --color'
alias la='ls -A --group-directories-first --color'
alias l='ls -CF --group-directories-first --color'

# Config
alias cfb="vim ~/.bashrc && source ~/.bashrc"
alias cfv="vim ~/.config/nvim/init.lua"

alias ssh="ssh -o LogLevel=quiet"

alias ..='cd ..'
alias ...='cd ../..'
alias r='. ranger'

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gitgraph="git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white) - %an%C(reset)%C(auto)%d%C(reset)'"

alias python="python3"

# Source machine-specific configurations
[ -f "${HOME}/.bashrc_local" ] && source "${HOME}/.bashrc_local"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD="true"
export PATH="$HOME/.julia/bin:$PATH"
export PATH="$HOME/opt/Fiji.app:$PATH"

alias path="echo \"${PATH//:/$'\n'}\""
. "$HOME/.cargo/env"
