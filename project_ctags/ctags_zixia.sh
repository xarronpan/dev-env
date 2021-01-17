#!/bin/bash

WORK_PATH=`echo ~/git`
PROJECT=zixia
PROJECT_ROOT="$WORK_PATH/$PROJECT"
CTAGS="(cd $PROJECT_ROOT; ctags-universal \
          --exclude=third-party/* \
          --exclude=build/* \
          --exclude=.cache/* \
          --exclude=.vscode/* \
          --exclude=.git/* \
          --exclude=.gitignore/* \
          --exclude=.gitmodules/* \
          --languages=C,C++,Protobuf \
          -R .)"

create_ctags () {
    echo $CTAGS
    eval $CTAGS
    echo "complete ctags"
    while : 
    do
        sleep 900
        echo $CTAGS
        eval $CTAGS
        echo "complete ctags"
    done
}

create_ctags >> $PROJECT.log 2>&1 &
