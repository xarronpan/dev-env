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
    bat ~/cheatsheets/languages/bash.sh ;;
  golang )
    bat ~/cheatsheets/languages/golang.go ;;
  python )
    mdless ~/cheatsheets/languages/python.md ;;
  vim-script )
    mdless ~/cheatsheets/languages/vimscript.md ;;
  gdb )
    bat ~/cheatsheets/tools/gdb.txt ;;
  git )
    bat ~/cheatsheets/tools/git.txt ;;
  tmux )
    bat ~/cheatsheets/tools/tmux.txt ;;
  vim )
    bat ~/cheatsheets/editors/vim.txt ;;
  *)
    exit0 ;;
esac
