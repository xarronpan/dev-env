#!/bin/bash

cd ~/notes/doc
TARGET=$(fzf --prompt='sections>' --header="select note sections:")
if [ -z $TARGET ]; then
  exit 0 
fi
vim -M $TARGET +'setlocal nu!' +'setlocal foldlevel=20'
