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

curl https://cht.sh/:cht.sh > ~/bin/cht.sh
chmod +x ~/bin/cht.sh

sudo apt-get install fd-find

sudo add-apt-repository ppa:aacebedo/fasd
sudo apt-get update
sudo apt-get install fasd

git clone https://github.com/cyrus-and/gdb-dashboard.git ~/.gdb-dashboard
cp ~/.gdb-dashboard/.gdbinit ~/

git clone https://github.com/hchbaw/zce.zsh.git ~/.zce

sudo apt-get install axel

git clone  https://github.com/facebook/PathPicker.git ~/.PathPicker
ln -s ~/.PathPicker/fpp ~/bin/fpp

sudo apt-get install diffstat
sudo apt-get install sshfs

git clone https://github.com/bigH/git-fuzzy.git ~/.git-fuzzy

sudo curl https://sh.rustup.rs -sSf | sh
cargo install exa

sudo apt-get install socat
sudo pip install ranger-fm

mkdir -p ~/tmp && cd ~/tmp
axel -n 10 https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb
sudo dpkg -i bat_0.17.1_amd64.deb

wget https://github.com/dandavison/delta/releases/download/0.6.0/git-delta_0.6.0_amd64.deb
sudo dpkg -i git-delta_0.6.0_amd64.deb

mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
git clone https://github.com/xarronpan/bat-solarized.git
bat cache --build

wget git.io/trans
mv trans ~/bin
chmod +x trans ~/bin/trans
