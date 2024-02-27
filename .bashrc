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
‘eval OPAM_SWITCH_PREFIX='/home/lld/.opam/default'; export OPAM_SWITCH_PREFIX; CAML_LD_LIBRARY_PATH='/home/lld/.opam/default/lib/stublibs:/usr/lib/ocaml/stublibs:/usr/lib/ocaml'; export CAML_LD_LIBRARY_PATH; OCAML_TOPLEVEL_PATH='/home/lld/.opam/default/lib/toplevel'; export OCAML_TOPLEVEL_PATH; MANPATH=':/home/lld/.opam/default/man'; export MANPATH; PATH='/home/lld/.opam/default/bin:/usr/local/texlive/2021/bin/x86_64-linux:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/var/lib/snapd/snap/bin:/home/lld/.fzf/bin:/opt/pdf4teachers/bin/:/home/lld/.local/bin/:/opt/piavpn/bin/:/opt/pdf4teachers/bin/:/home/lld/.local/bin/:/opt/piavpn/bin/'; export PATH;’
