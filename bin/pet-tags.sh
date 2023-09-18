#! /bin/bash
HEADER='types: shell vim docker k8s gdb helm git'
TAG=$(pet list|grep -oP '(?<=Tag: ).+'|sed 's/ /\n/g'|sort|uniq|sort -V -r|fzf --header="$HEADER" +s)
if [ -z $TAG ]; then
  exit 0
fi
echo "'#$TAG"
