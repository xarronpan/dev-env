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
mongodb-brief
mongodb
naming
docker
yaml
CHEET_SHEET_SECTIONS
)
case $SECTION in 
  cht )
    cht.sh --shell;;
  bash )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
            ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/bash.sh +'set nu!';;
  golang-brief )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetGolangCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/golang.go +'set nu!' ;;
  golang )
    vim -M ~/cheatsheets/a8m/golang-cheat-sheet/README.md +'set nu!' +Toc;;
  python-brief )
    vim -M ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/python.md +'set nu!' +Toc;;
  python )
    vim -M ~/cheatsheets/xarronpan/python-cheatsheet/README.md +'set nu!' +Toc;;
  cpp )
    vim -M ~/cheatsheets/mortennobel/cpp-cheatsheet/README.md +'set nu!' +Toc;;
  cpp11 )
    vim -M ~/cheatsheets/AnthonyCalandra/modern-cpp-features/CPP11.md +'set nu!' +Toc;;
  vim-script )
    vim -M ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/vimscript.md +'set nu!' +Toc;;
  gdb )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/gdb.txt +'set nu!';;
  git )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
            ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/git.txt +'set nu!';;
  tmux )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/tmux.txt +'set nu!';;
  vim )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/editors/vim.txt +'set nu!';;
  ansible )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/luckylittle/ansible-cheatsheet/ansible-cheatsheet.txt +'set nu!';;
  markdown )
    glow -p ~/cheatsheets/tchapi/markdown-cheatsheet/README.md;;
  sql )
    vim -M ~/cheatsheets/enochtangg/quick-SQL-cheatsheet/README.md +'set nu!' +Toc;;
  redis )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
            ~/cheatsheets/LeCoupa/awesome-cheatsheets/databases/redis.sh +'set nu!';;
  mongodb-brief )
    vim -M ~/cheatsheets/bradtraversy/mongodb_cheat_sheet.md/mongodb_cheat_sheet.md +'set nu!' +Toc;;
  mongodb )
    glow -p ~/cheatsheets/michaeltreat/Mongo_CheatSheet/README.md;;
  naming )
    vim -M ~/cheatsheets/xarronpan/naming-cheatsheet/README.md +'set nu!' +Toc;;
  docker )
    vim -M ~/cheatsheets/xarronpan/DockerCheatSheet/README.md +'set nu!' +Toc;;
  yaml)
    vim -M ~/cheatsheets/yren/yaml-cheatsheet/README.md +'set nu!' +Toc;;
  *)
    exit 0 ;;
esac
