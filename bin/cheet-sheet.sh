#!/bin/bash

SECTION=$(fzf --prompt='sections>' --header="select cheet sheet sections:" <<CHEET_SHEET_SECTIONS
cht
bash
golang-brief
golang
python-brief
python
cpp
cpp11
vim-script
gdb
git
tmux
vim
ansible
markdown
sql
redis
CHEET_SHEET_SECTIONS
)
case $SECTION in 
  cht )
    cht.sh --shell;;
  bash )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
            ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/bash.sh ;;
  golang-brief )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetGolangCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/golang.go ;;
  golang )
    vim -M ~/cheatsheets/a8m/golang-cheat-sheet/README.md ;;
  python-brief )
    vim -M ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/python.md ;;
  python )
    vim -M ~/cheatsheets/xarronpan/python-cheatsheet/README.md ;;
  cpp )
    vim -M ~/cheatsheets/mortennobel/cpp-cheatsheet/README.md ;;
  cpp11 )
    vim -M ~/cheatsheets/AnthonyCalandra/modern-cpp-features/CPP11.md ;;
  vim-script )
    vim -M ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/vimscript.md ;;
  gdb )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/gdb.txt ;;
  git )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
            ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/git.txt ;;
  tmux )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/tmux.txt ;;
  vim )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/editors/vim.txt ;;
  ansible )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/luckylittle/ansible-cheatsheet/ansible-cheatsheet.txt ;;
  markdown )
    glow -p ~/cheatsheets/tchapi/markdown-cheatsheet/README.md ;;
  sql )
    vim -M ~/cheatsheets/enochtangg/quick-SQL-cheatsheet/README.md ;;
  redis )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
            ~/cheatsheets/LeCoupa/awesome-cheatsheets/databases/redis.sh ;;
  *)
    exit 0 ;;
esac
