#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -1A --group-directories-first'
alias vi='vim'

# run in vi mode
set -o vi

PS1='[\u@\h \W]\$ '

export NPM_CONFIG_PREFIX=$HOME/.local/
export PATH="/home/$USER/go/bin:/home/$USER/.local/bin:$NPM_CONFIG_PREFIX/bin:$PATH"
# We have this against messing with Portage files.
# Bonus: now you can `npm install -g` without root.
# According to
# https://wiki.g.o/wiki/Node.js#npm
# https://stackoverflow.com/a/63026107/1879101
# https://www.reddit.com/r/Gentoo/comments/ydzkml/nodejs_is_it_ok_to_install_global_packages/

