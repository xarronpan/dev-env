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

sudo apt-get install xsel

sudo apt-get install fd-find
sudo apt-get install ripgrep

sudo add-apt-repository ppa:aacebedo/fasd
sudo apt-get update
sudo apt-get install fasd

git clone https://github.com/cyrus-and/gdb-dashboard.git ~/.gdb-dashboard
cp ~/.gdb-dashboard/.gdbinit ~/

git clone https://github.com/hchbaw/zce.zsh.git ~/.zce

sudo apt-get install axel

sudo apt-get install sshfs

sudo apt-get install parallel

git clone https://github.com/bigH/git-fuzzy.git ~/.git-fuzzy

sudo curl https://sh.rustup.rs -sSf | sh
cargo install exa

sudo apt-get install socat
sudo apt-get install dateutils
sudo pip install ranger-fm
sudo pip3 install ansible

mkdir -p ~/tmp && cd ~/tmp
axel -n 10 https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb
sudo dpkg -i bat_0.17.1_amd64.deb

wget https://github.com/dandavison/delta/releases/download/0.6.0/git-delta_0.6.0_amd64.deb
sudo dpkg -i git-delta_0.6.0_amd64.deb

wget https://github.com/charmbracelet/glow/releases/download/v1.4.1/glow_1.4.1_linux_amd64.deb
sudo dpkg -i glow_1.4.1_linux_amd64.deb

wget https://github.com/harelba/q/releases/download/2.0.19/q-text-as-data_2.0.19-2_amd64.deb
sudo dpkg -i q-text-as-data_2.0.19-2_amd64.deb

wget https://github.com/browsh-org/browsh/releases/download/v1.8.2/browsh_1.8.2_linux_amd64
x browsh_1.8.2_linux_amd64
mv browsh_1.8.2_linux_amd64 ~/bin/browsh

mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
git clone https://github.com/xarronpan/bat-solarized.git
bat cache --build

sudo pip install cppman

wget git.io/trans
mv trans ~/bin
chmod +x trans ~/bin/trans

git clone https://github.com/skywind3000/awesome-cheatsheets ~/cheatsheets/skywind3000/awesome-cheatsheets
git clone https://github.com/xarronpan/python-cheatsheet ~/cheatsheets/xarronpan/python-cheatsheet
git clone https://github.com/a8m/golang-cheat-sheet ~/cheatsheets/a8m/golang-cheat-sheet
git clone https://github.com/mortennobel/cpp-cheatsheet ~/cheatsheets/mortennobel/cpp-cheatsheet
git clone https://github.com/AnthonyCalandra/modern-cpp-features ~/cheatsheets/AnthonyCalandra/modern-cpp-features
git clone https://github.com/tchapi/markdown-cheatsheet ~/cheatsheets/tchapi/markdown-cheatsheet
git clone https://github.com/luckylittle/ansible-cheatsheet ~/cheatsheets/luckylittle/ansible-cheatsheet
git clone https://github.com/enochtangg/quick-SQL-cheatsheet ~/cheatsheets/enochtangg/quick-SQL-cheatsheet
git clone https://github.com/LeCoupa/awesome-cheatsheets ~/cheatsheets/LeCoupa/awesome-cheatsheets
git clone https://gist.github.com/bradtraversy/f407d642bdc3b31681bc7e56d95485b6 ~/cheatsheets/bradtraversy/mongodb_cheat_sheet.md
git clone https://github.com/michaeltreat/Mongo_CheatSheet ~/cheatsheets/michaeltreat/Mongo_CheatSheet
git clone https://github.com/xarronpan/naming-cheatsheet ~/cheatsheets/xarronpan/naming-cheatsheet
git clone https://github.com/xarronpan/DockerCheatSheet ~/cheatsheets/xarronpan/DockerCheatSheet
git clone https://github.com/yren/yaml-cheatsheet ~/cheatsheets/yren/yaml-cheatsheet
git clone https://github.com/xarronpan/k8s-cheatsheet.git ~/cheatsheets/xarronpan/k8s-cheatsheet
git clone https://github.com/xarronpan/helm-cheatsheet.git ~/cheatsheets/xarronpan/helm-cheatsheet

git clone https://github.com/xarronpan/dev-env ~/notes
