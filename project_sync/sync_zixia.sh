#!/bin/bash

WORK_PATH=$(dirname $(readlink -f $0))
#$WORK_PATH/sync.sh 14.116.173.26 zixia >> zixia.log 2>&1 &
$WORK_PATH/sync.sh 14.116.173.152 zixia >> zixia.log 2>&1 &
