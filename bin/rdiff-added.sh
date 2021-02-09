#!/bin/bash
if [ $# != 2 ]; then
  echo "usage rdiff.sh dir1 dir2"
  exit 1
fi

diff -rq $1 $2|diffstat -p0 -K|grep -v differ|fpp -ko -c vim
