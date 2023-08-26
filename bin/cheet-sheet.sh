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
k8s
helm
helm-cmd
regex
CHEET_SHEET_SECTIONS
)
case $SECTION in 
  cht )
    cht.sh --shell;;
  bash )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
            ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/bash.sh +'setlocal nu!' +'setlocal foldlevel=20';;
  golang-brief )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetGolangCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/golang.go +'setlocal nu!' +'setlocal foldlevel=20';;
  golang )
    vim -M ~/cheatsheets/a8m/golang-cheat-sheet/README.md +'setlocal nu!' +'setlocal foldlevel=20';;
  python-brief )
    vim -M ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/python.md +'setlocal nu!' +'setlocal foldlevel=20';;
  python )
    vim -M ~/cheatsheets/xarronpan/python-cheatsheet/README.md +'setlocal nu!' +'setlocal foldlevel=20';;
  cpp )
    vim -M ~/cheatsheets/mortennobel/cpp-cheatsheet/README.md +'setlocal nu!' +'setlocal foldlevel=20';;
  cpp11 )
    vim -M ~/cheatsheets/AnthonyCalandra/modern-cpp-features/CPP11.md +'setlocal nu!' +'setlocal foldlevel=20';;
  vim-script )
    vim -M ~/cheatsheets/skywind3000/awesome-cheatsheets/languages/vimscript.md +'setlocal nu!' +'setlocal foldlevel=20';;
  gdb )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/gdb.txt +'setlocal nu!' +'setlocal foldlevel=20';;
  git )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
            ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/git.txt +'setlocal nu!' +'setlocal foldlevel=20';;
  tmux )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/tools/tmux.txt +'setlocal nu!' +'setlocal foldlevel=20';;
  vim )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/skywind3000/awesome-cheatsheets/editors/vim.txt +'setlocal nu!' +'setlocal foldlevel=20';;
  ansible )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
           -c 'syntax match CheetSheetMarker "#"' \
           -c 'highlight CheetSheetMarker ctermfg=10' \
           ~/cheatsheets/luckylittle/ansible-cheatsheet/ansible-cheatsheet.txt +'setlocal nu!' +'setlocal foldlevel=20';;
  markdown )
    glow -p ~/cheatsheets/tchapi/markdown-cheatsheet/README.md;;
  sql )
    vim -M ~/cheatsheets/enochtangg/quick-SQL-cheatsheet/README.md +'setlocal nu!' +'setlocal foldlevel=20';;
  redis )
    vim -M -c 'setlocal foldmethod=expr' \
           -c 'setlocal foldexpr=GetShellCheatSheetFold(v:lnum)' \
           -c 'setlocal foldtext=NeatFoldText()' \
            ~/cheatsheets/LeCoupa/awesome-cheatsheets/databases/redis.sh +'setlocal nu!' +'setlocal foldlevel=20';;
  mongodb-brief )
    vim -M ~/cheatsheets/bradtraversy/mongodb_cheat_sheet.md/mongodb_cheat_sheet.md +'setlocal nu!' +'setlocal foldlevel=20';;
  mongodb )
    glow -p ~/cheatsheets/michaeltreat/Mongo_CheatSheet/README.md;;
  naming )
    vim -M ~/cheatsheets/xarronpan/naming-cheatsheet/README.md +'setlocal nu!' +'setlocal foldlevel=20';;
  docker )
    vim -M ~/cheatsheets/xarronpan/DockerCheatSheet/README.md +'setlocal nu!' +'setlocal foldlevel=20';;
  yaml)
    vim -M ~/cheatsheets/yren/yaml-cheatsheet/README.md +'setlocal nu!' +'setlocal foldlevel=20';;
  k8s )
    vim -M ~/cheatsheets/xarronpan/k8s-cheatsheet/k8s.md +'setlocal nu!' +'setlocal foldlevel=20';;
  helm )
    vim -M ~/cheatsheets/xarronpan/helm-cheatsheet/helm.md +'setlocal nu!' +'setlocal foldlevel=20';;
  helm-cmd )
    vim -M ~/cheatsheets/xarronpan/helm-cheatsheet/helm_cmd.md +'setlocal nu!' +'setlocal foldlevel=20';;
  regex )
    browsh 'https://remram44.github.io/regex-cheatsheet/regex.html#syntax-basics' ;;
  *)
    exit 0+'setlocal foldlevel=20';;
esac
