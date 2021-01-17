#!/bin/bash

WORK_PATH=$(dirname $(readlink -f $0))
$WORK_PATH/sync.sh 14.116.173.26 pyh2cimtools >> pyh2cimtools.log 2>&1 &
