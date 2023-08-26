#!/bin/bash
sudo apt-get install bison
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.16
gvm use go1.16
go install -v golang.org/x/tools/cmd/godoc@latest
mkdir -p ~/tmp
cd ~/tmp && wget https://github.com/alecthomas/chroma/releases/download/v2.8.0/chroma-2.8.0-linux-amd64.tar.gz
x chroma-2.8.0-linux-amd64.tar.gz
mv chroma ~/bin
