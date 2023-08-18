#!/bin/bash

cd ~/notes/doc
TARGET=$(fzf --prompt='sections>' --header="select note sections:")
vim -M $TARGET +Toc
