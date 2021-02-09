#!/bin/bash
if [ $# != 2 ]; then
  echo "usage rdiff.sh dir1 dir2"
  exit 1
fi

diff -qr $1 $2|grep File|sed 's/Files\|and\|differ//g'|fpp -ai -ko  -c 'echo $F|xargs -o vimdiff'
