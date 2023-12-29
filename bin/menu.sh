#!/bin/bash

SECTION=$(fzf --prompt='sections>' --header="select cheet sheet sections:" <<MENU_SECTIONS
ansible-hosts
ansible-groups
ranger
MENU_SECTIONS
)
case $SECTION in 
  ansible-hosts )
    tmux split-window -v $HOME/bin/ansible-hosts-tmux.sh $1;;
  ansible-groups )
    tmux split-window -v $HOME/bin/ansible-groups-tmux.sh $1;;
  ranger )
    tmux split-window -v -c $2 $HOME/bin/ranger.sh $1;;
  *)
    exit 0;;
esac
