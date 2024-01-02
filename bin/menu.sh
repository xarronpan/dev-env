#!/bin/bash

SECTION=$(fzf --prompt='sections>' --header="select cheet sheet sections:" <<MENU_SECTIONS
ansible-hosts
ansible-groups
ranger
edit-completion-dictionay
MENU_SECTIONS
)
case $SECTION in 
  ansible-hosts )
    tmux split-window -v $HOME/bin/ansible-hosts-tmux.sh $1;;
  ansible-groups )
    tmux split-window -v $HOME/bin/ansible-groups-tmux.sh $1;;
  ranger )
    tmux split-window -v -c $2 $HOME/bin/ranger.sh $1;;
  edit-completion-dictionay )
    tmux split-window -v vim $HOME/.compl_dic;;
  *)
    exit 0;;
esac
