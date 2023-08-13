#! /bin/bash
PREFIX=~/.tmux/min-pane
mkdir -p $PREFIX
SIZE_FILE=$PREFIX/$(tmux display-message -p "#{pid}-#{pane_id}")
#echo $SIZE_FILE
if [ -e $SIZE_FILE ]; then
  #echo "file exists"
  SIZE=$(cat $SIZE_FILE)
  tmux resize-pane -y $SIZE
  rm $SIZE_FILE
else
  #echo "file not exists"
  SIZE=$(tmux display-message -p "#{pane_height}")
  echo $SIZE > $SIZE_FILE
  tmux resize-pane -y 1
fi
