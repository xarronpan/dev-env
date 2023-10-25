#!/bin/bash
sudo apt-get install bison
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.16
gvm use go1.16
go install -v golang.org/x/tools/cmd/godoc@latest

gvm install go1.20 -B
