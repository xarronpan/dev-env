#!/bin/bash
sudo apt-get install zsh

mkdir -p ~/.zsh/antigen
curl -L git.io/antigen > ~/.zsh/antigen/antigen.zsh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
git clone https://github.com/xarronpan/fzf-tab-completion ~/.fzf-tab-completion

mkdir -p ~/bin
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
chmod +x ~/bin/tldr

sudo apt-get install fd-find

sudo add-apt-repository ppa:aacebedo/fasd
sudo apt-get update
sudo apt-get install fasd

git clone https://github.com/cyrus-and/gdb-dashboard.git ~/.gdb-dashboard
cp ~/.gdb-dashboard/.gdbinit ~/

git clone https://github.com/hchbaw/zce.zsh.git ~/.zce

sudo apt-get install axel

mkdir -p ~/tmp && cd ~/tmp
axel -n 10 https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb
sudo dpkg -i bat_0.17.1_amd64.deb

wget https://github.com/dandavison/delta/releases/download/0.6.0/git-delta_0.6.0_amd64.deb
sudo dpkg -i git-delta_0.6.0_amd64.deb
