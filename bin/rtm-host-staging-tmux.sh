#!/usr/bin/env bash
tmux split-window -v -l100% tmux\ send-keys\ \-t\ $1\ \"\$\($HOME/bin/rtmsh\)\"
