#!/bin/bash
PARAM=$(man -k '.*'|fzf --preview '~/bin/preview_man.sh {}')
~/bin/show_man.sh $PARAM
