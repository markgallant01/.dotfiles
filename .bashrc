#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -1A --group-directories-first'

PS1='[\u@\h \W]\$ '

