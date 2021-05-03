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

if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
fi

export PATH=$PATH:/opt/pdf4teachers/
export PATH=$PATH:/home/lld/.local/bin/
