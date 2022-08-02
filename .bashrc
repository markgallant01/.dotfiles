#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -1A --group-directories-first'

# the sed command here removes the warning / info message
# from tree about not showing directory contents because they're
# over the file limit. It messes up the look of the tree.
alias tree="tree -CF --filelimit 25 --filesfirst | sed 's/\[[0-9]\+ entries exceeds filelimit, not opening dir\]//g'"
PS1='[\u@\h \W]\$ '

