#!/usr/bin/env bash
tmux split-window $options tmux\ send-keys\ \-t\ $1\ \"\$\($HOME/bin/pet-tags.sh\)\"
