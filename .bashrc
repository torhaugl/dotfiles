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

# GENERAL ALIASES
alias ls='ls --group-directories-first --color'
alias sl='ls --group-directories-first --color'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

cdls() {
        local dir="$1"
        local dir="${dir:=$HOME}"
        if [[ -d "$dir" ]]; then
                cd "$dir" >/dev/null; ls --color=auto
        else
                echo "bash: cdls: $dir: Directory not found"
        fi
}
alias cd=cdls

# Config
alias cfb="vim ~/.bashrc && source ~/.bashrc"
alias cfv="vim ~/.vimrc"

alias ssh="ssh -o LogLevel=quiet"

alias ..='cd ..'
alias ...='cd ../..'
alias r='. ranger'

alias gs="git status"
alias ga="git add"
alias gc="git commit"

alias python="python3"

# Source machine-specific configurations
[ -f "$HOME/.bashrc_local" ] && source "$HOME/.bashrc_local"
