#!/bin/bash

ENV=`ls ~/.inventory|fzf`
if [ -z "$ENV" ]; then
  exit 0
fi
ansible-inventory -i ~/.inventory/$ENV --list| \
  jq -r '.|keys| join(" ")'| \
  xargs -n 1| \
  grep -v 'all\|_meta'| \
  fzf
