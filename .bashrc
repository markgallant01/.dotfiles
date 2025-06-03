#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -Av --color=auto --group-directories-first'
alias ll='ls -1A --group-directories-first'
alias vi='vim'
alias vim='nvim'

# run in vi mode
set -o vi

PS1='[\u@\h \W]\$ '

export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

