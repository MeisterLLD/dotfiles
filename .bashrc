#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export EDITOR=vim
export SYSTEMD_EDITOR=vim

alias gvim='gvim --remote-silent'


alias config='/usr/bin/git --git-dir=/home/lld/.cfg/ --work-tree=/home/lld'
