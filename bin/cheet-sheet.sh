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
    vim -M -c 'setlocal foldmethod=expr' -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' ~/cheatsheets/languages/bash.sh ;;
  golang )
    vim -M ~/cheatsheets/languages/golang.go ;;
  python )
    vim -M ~/cheatsheets/languages/python.md ;;
  vim-script )
    vim -M ~/cheatsheets/languages/vimscript.md ;;
  gdb )
    vim -M -c 'setlocal foldmethod=expr' -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' ~/cheatsheets/tools/gdb.txt ;;
  git )
    vim -M -c 'setlocal foldmethod=expr' -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' ~/cheatsheets/tools/git.txt ;;
  tmux )
    vim -M -c 'setlocal foldmethod=expr' -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' ~/cheatsheets/tools/tmux.txt ;;
  vim )
    vim -M -c 'setlocal foldmethod=expr' -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' ~/cheatsheets/editors/vim.txt ;;
  *)
    exit0 ;;
esac
