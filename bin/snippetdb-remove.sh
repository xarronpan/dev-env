#!/bin/bash
$HOME/.tmux-butler/scripts/snippetdb list| \
  cut -d ' ' -f 1 | \
  fzf -m --bind ctrl-t:toggle-all --prompt='keys-to-remove>' | \
  xargs -n 1 -I{} $HOME/.tmux-butler/scripts/snippetdb remove {}
