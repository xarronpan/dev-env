#! /bin/bash
TAG=$(pet list|grep -oP '(?<=Tag: ).+'|sed 's/ /\n/g'|sort|uniq|fzf)
if [ -z $TAG ]; then
  exit 0
fi
echo "'#$TAG"
