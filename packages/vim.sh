sudo apt install silversearcher-ag
sudo apt install universal-ctags

#下面两项工具用于vim的ycm插件生成clang编译数据库使用
sudo pip install compiledb
sudo pip install compdb
sudo pip install cpplint
sudo pip install flake8

sudo apt install clang-format

#对airline有一些修改，但是由于成本原因没有做成一个独立的插件, 已覆盖的方式进行配置
cp vim-airline-themes/solarized_flood.vim ~/.vim/bundle/vim-airline-themes/autoload/airline/themes 

#ycm
sudo apt install build-essential cmake vim-nox python3-dev
sudo apt install mono-complete golang nodejs default-jdk npm

cd ~/.vim/bundle/YouCompleteMe
sudo python3 install.py --all

cd ~/.vim/bundle/vim-doge/scripts
./install.sh

cd ~
sudo apt-get install clang libclang-10-dev
git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-10 \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-10/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-10/
cmake --build Release
cd Release && sudo make install
