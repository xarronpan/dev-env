#!/bin/bash
PARAM=$(man -k '.*'|fzf --preview '~/bin/show_man.sh {}')
~/bin/show_man.sh $PARAM
