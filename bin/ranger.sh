#!/usr/bin/env bash

# $1 ... tmux pane ID
#tmux split-window -v tmux\ send-keys\ \-t\ $1\ \"\$\(fzf\)\"
#tmux split-window -v 'ranger.sh'

IFS=$'\t\n'
tempfile="$(mktemp -t tmp.XXXXXX)"
ranger --cmd="map Q chain shell echo %d/%f > "$tempfile"; quitall"
if [[ -f "$tempfile" ]]; then
  echo "$tempfile"
  tmux send-keys -t $1 "$(cat $tempfile)"
  rm -f -- "$tempfile" 2>/dev/null
fi
