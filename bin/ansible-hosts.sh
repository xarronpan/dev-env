#!/bin/bash

ENV=`ls ~/.inventory|fzf`
if [ -z "$ENV" ]; then
  exit 0
fi
GROUP_IDS=`ansible-inventory -i ~/.inventory/$ENV --list| \
  jq -r '.|keys| join(" ")'| \
  xargs -n 1| \
  grep -v 'all\|_meta'| \
  fzf -m`
if [ -z "$GROUP_IDS" ]; then
  exit 0
fi
for GROUP_ID in $GROUP_IDS; do
  ansible-inventory -i ~/.inventory/$ENV --list| \
  jq -r '.["'$GROUP_ID'"]|.hosts|join("\n")'
done | sort | uniq | fzf -m --bind ctrl-t:toggle-all|tr '\n' ' '
