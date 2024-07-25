#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -1A --group-directories-first'
alias vi='vim'
alias vim='nvim'

# run in vi mode
set -o vi

PS1='[\u@\h \W]\$ '

export EDITOR=nvim

