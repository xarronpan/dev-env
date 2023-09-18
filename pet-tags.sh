#! /bin/bash
TAG=$(pet list|grep -oP '(?<=Tag: ).+'|sed 's/ /\n/g'|sort|uniq|sort -V -r|fzf +s)
if [ -z $TAG ]; then
  exit 0
fi
echo "'#$TAG"
