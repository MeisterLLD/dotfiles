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

export PATH=$PATH:/opt/pdf4teachers/bin/
export PATH=$PATH:/home/lld/.local/bin/
export PATH=$PATH:/opt/piavpn/bin/

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

alias git='LANG=en_US.UTF-8 git'
