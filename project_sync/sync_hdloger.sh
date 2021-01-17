#!/bin/bash

WORK_PATH=$(dirname $(readlink -f $0))
$WORK_PATH/sync.sh 192.168.133.163 hdloger >> hdloger.log 2>&1 &
