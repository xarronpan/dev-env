#! /bin/bash
TARGET=$(tmux list-sessions | sed -E 's/:.*$//' | grep -v ^$(tmux display-message -p '#S')\$ | fzf --reverse)

if [[ -z $TARGET ]]; then
  exit 1
fi

tmux switch-client -t $TARGET
