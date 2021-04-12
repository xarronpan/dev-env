#!/bin/bash

SECTION=$(fzf --prompt='sections>' --header="select cheet sheet sections:" <<CHEET_SHEET_SECTIONS
cht
bash
golang
python
vim-script
gdb
git
tmux
vim
CHEET_SHEET_SECTIONS
)
case $SECTION in 
  cht )
    cht.sh --shell;;
  bash )
    bat --style=plain ~/cheatsheets/languages/bash.sh ;;
  golang )
    bat --style=plain ~/cheatsheets/languages/golang.go ;;
  python )
    glow -p ~/cheatsheets/languages/python.md ;;
  vim-script )
    glow -p ~/cheatsheets/languages/vimscript.md ;;
  gdb )
    bat --style=plain ~/cheatsheets/tools/gdb.txt ;;
  git )
    bat --style=plain ~/cheatsheets/tools/git.txt ;;
  tmux )
    bat --style=plain ~/cheatsheets/tools/tmux.txt ;;
  vim )
    bat --style=plain ~/cheatsheets/editors/vim.txt ;;
  *)
    exit0 ;;
esac
