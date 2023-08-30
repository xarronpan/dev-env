sudo apt install silversearcher-ag
sudo apt install universal-ctags

sudo apt install build-essential cmake vim-nox python3-dev
sudo apt install mono-complete golang nodejs default-jdk npm

cd ~/.vim/bundle/YouCompleteMe
sudo python3 install.py --all

#对airline有一些修改，但是由于成本原因没有做成一个独立的插件, 已覆盖的方式进行配置
cp vim-airline-themes/solarized_flood.vim ~/.vim/bundle/vim-airline-themes/autoload/airline/themes 

#下面两项工具用于vim的ycm插件生成clang编译数据库使用
sudo pip install compiledb
sudo pip install compdb
sudo pip install cpplint
sudo pip install flake8

sudo apt install clang-format
