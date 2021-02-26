sudo apt install software-properties-common
sudo add-apt-repository ppa:greymd/tmux-xpanes
sudo apt update
sudo apt install tmux-xpanes
sudo apt install gawk
sudo gem install tmuxinator
git clone --depth 1 https://github.com/woodstok/tmux-butler ~/.tmux-butler
mkdir -p ~/tmp && cd ~/tmp
wget https://github.com/knqyf263/pet/releases/download/v0.3.0/pet_0.3.0_linux_amd64.deb
sudo dpkg -i pet_0.3.0_linux_amd64.deb
