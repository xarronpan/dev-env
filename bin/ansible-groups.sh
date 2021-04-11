#!/bin/bash

HEADER='choose from ansible inventory:'

ENV=`ls ~/.inventory|fzf --prompt='envs>' --header="$HEADER"`
if [ -z "$ENV" ]; then
  exit 0
fi
ansible-inventory -i ~/.inventory/$ENV --list| \
  jq -r '.|keys| join(" ")'| \
  xargs -n 1| \
  grep -v 'all\|_meta'| \
  fzf --prompt='groups>' --header="$HEADER"
