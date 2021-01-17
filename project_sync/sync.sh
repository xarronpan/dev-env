#!/bin/bash

HOST=$1
PROJECT=$2
RSYNC="rsync -avz --exclude="$PROJECT/.git" \
      --exclude="$PROJECT/.gitmodules" \
      --exclude="$PROJECT/.gitignore" \
      --exclude="$PROJECT/.cache" \
      --exclude="$PROJECT/.vscode" \
      --exclude="$PROJECT/tags" \
      --exclude="$PROJECT/build" \
      ~/git/$PROJECT $HOST:~/git" 

eval $RSYNC
while inotifywait -r -e modify,create,delete,move ~/git/$PROJECT; do
    eval $RSYNC
done
