vim的权威教程请参考： https://github.com/iggredible/Learn-Vim
# 配置
## vim
在ubuntu 20.04上，以spf13为基础，配置下面的命令。参考说明安装  https://github.com/spf13/spf13-vim
此外对spf13有些修改，可以通过拷贝 https://github.com/xarronpan/spf13-vim 中的配置来修改sfp13中的行为

vim的个性化配置: 这个配置可以上传到git，进行配置
在 ~/.vimrc.local 中增加下面配置。目前这个配置可以在 https://github.com/xarronpan/dev-env.git 上访问到

解释:
上面包括了不少youcompleteme的命令，后续安装youcompleteme的文档中会进行解释
其中 ACK，AG的作用是创建一个命令的别名。默认Ack，Ag的行为都是搜索当前打开的文件目录下的文件，所以很难用。
Rooter的作用是转到当前git的根目录下 (以及其他可以自定义的项目根目录)。
set undofile 会开启 persist undo的功能。set undodir 设置undo log存放的位置。 ~/.vim/undodir 需要提前创建好，否则
persist undo就不会能够正常工作。
persist undo + undo tree插件，对于一些临时性的脚本，可以做到能够随时恢复文件版本的轻量级存储方案。undo log的信息可以
自己进行清理
g:signify_priority设置 vim signify 插件的展现优先级。否则当与youcomplete同时使用时，这个插件的内容会覆盖youcompleteme
的语法错误提示，导致语法错误提示功能无法正常使用
set ttymouse=xterm2 则用于在vim中支持鼠标的拖拽功能。当这个功能打开时，我们可以直接使用鼠标来改变vim各个窗体的大小，
非常方便
定义的FAg命令，以及FBLines命令，只是使用了 extend('<cword>') 命令获取当前光标下的字符串作为输入字符串调用fzf的Ag以及
BLines函数。这样子做是模仿了Ack的行为
加载 .workspace.vim 的目的是为了加载一些项目专用的配置。比如项目的ctags生成脚本，项目tab的设置等，都是项目专用的。

nerdtree的配置不符合多数ide的使用习惯:
每次打开文件tree组件都会消失，执行 `echo 'let NERDTreeQuitOnOpen=0' >> ~/.vimrc.local` 将配置增加到 .vimrc.local 
个性化配置当中

在 ~/.vimrc.before.local 中增加下面配置
```vim
let g:spf13_no_fastTabs = 1```
(spf13默认将HLM给remap了，这项配置是用于恢复该配置的)

## rsync
由于我们将 编辑虚拟机 与开发虚拟机分离，需要一种方便的方案，在编辑虚拟机上面编辑时，将信息同步到 开发虚拟机
这样子我们就可以使用一个tmux分屏登录到 开发虚拟机上面进行编译，调试，看起来与编辑虚拟机编辑窗口形成了一个集成开发环境
对于每个git上面的项目中在.workspance.vim中增加一个autocmd，当vim发生了buffer写的时候，将项目目录下的源代码都同步到远
端去. 注意到很多与源代码无关的东西，都需要进行过滤

.workspace.vim:

```vim
autocmd BufWritePost * silent !(
\ cd ~/git/zixia &&
\ rsync -avz --delete --exclude=".*"•
\ --exclude="*.o"•
\ --exclude="/tags"•
\ --exclude="/build"•
\ --exclude="/output"•
\ . 14.116.173.26:~/git/zixia
\ >> .rsync.log 2>&1 &
    )
```
## ctags
vim中的很多功能都依赖与ctags的生成。比如在ycm所依赖的信息不全的时候，ctags仍然可以进行使用
我们依赖 ludovicchabant/vim-gutentags 来生成ctags
由于在有些项目中，引用的第三方文件很多，有可能会造成ctags话大量时间生成无用的符号，所以需要定制ctags调用的参数

若需要特殊的ctags配置时，可以在项目的目录增加 .gutctags，输入下面的配置: 

.gutctags:
```bash
--exclude=third-party/*
--exclude=build/*
--exclude=.cache/*
--exclude=.vscode/*
--exclude=.git/*
--exclude=.gitignore/*
--exclude=.gitmodules/*
--languages=C,C++,Protobuf
-R
```
## secrut crt
鼠标的滚动事件需要发送到远端，这样子 confortable motion插件就可以使用鼠标互动键来滚动vim中的代码
SessionOptions → Terminal  勾选 Send Scroll wheel event to remote
vim在xterm下的行为，可以参考下面这篇文章。鼠标的中间可以用于黏贴
https://zhuanlan.zhihu.com/p/38477934

# 升级
再更新了youcompleteme插件之后，有时候ycm的二进制服务, 或者依赖的服务需要进行升级后，方能进行使用
目前遇到过的情况包括:
1 整个依赖的二进制服务需要重新编译
  这种情况下，只要按照编译的方式重新编译即可

2 clangd服务需要重新升级
  这种情况下，会发现c++的go refernce功能无法工作，使用YcmDebugInfo发现clangd没有启动
造成这个现象的原因是ycm依赖的clangd服务升级了，需要升级clangd服务。
  处理方法:
  进入 ~/.vim/bundle/YouCompleteMe, 执行
  mv ~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clangd \
  ~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clangdbak 
  ./install.py --skip-build  --clangd-completer  #不需要重新编译ycm, 只是重新下载clangd
  确认clangd安装成功后，再删除 ~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clangdbak 


# 常用功能
leader键在下述的配置中是 ','

## buffer/window/tab
### 内置功能
在vim中，窗口和buffer是不同的概念。真正进行编辑的是buffer，而window是buffer的view
所以窗口被关闭了，但是buffer是不会被关闭的。但是buffer被关闭，则窗口也要跟着一起关闭
https://github.com/iggredible/Learn-Vim/blob/master/ch02_buffers_windows_tabs.md
tabs则类似于tmux中的window，是vim windows的集合。
目前不同的tab是共享同一个nerdtree的，所以不同的tab不能代表不同的项目
最佳实践，是tab用于打开同一个项目中的不同需要反复创建的窗口，降低每次需要重建窗口的需要
比如说一个tab浏览代码，一个tab做Git diff

打开新buffer
:enew 在新窗口中打开一个empty buffer。下一步通过-命令来选择需要打开的文件。见dirvish插件的描述
:vnew 在新的垂直窗口中打开一个empty buffer。下一步通过-命令来选择需要打开的文件。见dirvish插件的描述
:e    重新打开当前文件
:tabnew 创建一个新的tab，并且创建一个新的buffer (<leader>tn)
:tabclose 关闭一个tab (<leader>tc)
```bash
vim -O file1.txt file2.txt #垂直打开若干个文件
vim -o file1.txt file2.txt #水平打开若干个文件
```
切换buffer: :bn, :bN, :b number 详见 https://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers
切换tab可以直接上鼠标进行切换, 或者键入ngt来命令来进行切换

垂直打开窗口
ctrl+w + v

水平打开窗口
ctrl+w + S

关闭当前窗口
ctrl+w + C

全屏使用下面两个命令来实现
ctrl+w + | 垂直伸展到最大
ctrl+w + _ 水平伸展到最大
垂直加水平伸展就基本等于全屏了
退出全部使用下面的命令来实现
<leader> + = 以等高的方式调整目前的窗口布局
gt 跳转到下个tab
gT 跳转到上个tab
ngt 跳转到第n个tab
zl 水平右滚屏
zh 水平左滚屏

### tab重命名支持:gcmt/taboo.vim 插件
这个插件支持对tab进行rename，就与在使用tmux中，通过名字来区分任务一样
命令:
:RT newtabname   将当前tab的名称调整成newtabname

### 简化窗体大小调整:winresizer插件
使用‘simeji/winresizer’ 插件来调整vim的窗体大小
键入ctrl+x 进入窗体调整模式，hjkl用于调整当前获得焦点的窗口
键入e间后可以调整窗体调整模式。其中window move的模式可以用于调整窗体的位置


## 光标移动
### 内置光标移动
vim上的基础操作，请参考: https://github.com/iggredible/Learn-Vim/blob/master/ch05_moving_in_file.md
fa 光标向前跳到a字符, 在按；重复fa这个动作，再按，重复Fa这个动作 (目前,操作已经被remap掉了，但是可以在tmux的
vi copy mode下使用这个键进行拷贝)
Fa 光标向后跳到a字符，在按；重复fa这个动作，再按，重复Fa这个动作 (目前,操作已经被remap掉了，但是可以在tmux的
vi copy mode下使用这个键进行拷贝)
0 找到行头
w 跳到下个单词开始
e 跳到下个单词结束
b 跳到上个单词开始
W 下个以space分割的单词开始
E 下个以space分割的单词结束
B 上个以space分割的单词开始
gi 回到同一个文件上一次进入insert mode的位置，并且进入insert mode
   这个动作特别适合拷贝粘贴的场景。本身在某个位置编辑，然后需要到同一个文件的其他地方拷贝
   再跳回来。如果是分屏的情况下做拷贝黏贴，则可以使用窗口的选择操作，即可回到上次的位置

page up: ctrl+u
page down: ctrl+d
jump defination:  Ctrl-]
jump defination with select支持重名tag的跳转: g Ctrl-]
jump forward: ctrl+o
jump backward: ctrl+i

% 调转到嵌套 {} 的末尾。sfp13上面安装了matct-it插件，能够识别代码中的关键字，从而跳转到代码块的结束

### easymositon插件光标移动
s 启动easy motion，找一个字符, 并跳转到对应的位置中
<leader> + w 使用easy motion跳转到附近的单词开始。可以跨窗体，能够在特殊的buffer，visual模式下使用。不能与vim的
             动作共用。在中文的文档中进行浏览编辑时，这个动作尤其有用
<leader> <leader> + l 使用easy motion跳转到某行。可以跨窗体，能够在特殊的buffer，visual模式下使用。不能与vim的动
                      作共用
<leader> <leader> + w 使用easy motion后向跳转到附近的单词开始 (与vim w的定义相同)。 这个功能可以在visual模式下启用，
                      用于选定文本，以及在一些特殊的buffer，比如nerdtree中使用。不能跨窗体
<leader> <leader> + b 使用easy motion前向跳转到附近的单词结束 (与vim b的定义相同) 。 这个功能可以在visual模式下启用，
                      用于选定文本，以及在一些特殊的buffer，比如nerdtree中使用。不能跨窗体
<leader> <leader> + e 使用easy motion后向跳转到附近的单词结束 (与vim b的定义相同) 。 这个功能可以在visual模式下启用，
                      用于选定文本，以及在一些特殊的buffer，比如nerdtree中使用。不能跨窗体
<leader> <leader> + j 使用easy motion后向跳转到某行 (与vim j的定义相同)。这个功能可以在visual模式下启用，用于选定文本
                      ，以及在一些特殊的buffer，比如nerdtree中使用。不能跨窗体
<leader> <leader> + k 使用easy motion后向跳转到某行 (与vim k的定义相同)。这个功能可以在visual模式下启用，用于选定文本
                      ，以及在一些特殊的buffer，比如nerdtree中使用。不能跨窗体


### comfortable-motion插件
yuttie/comfortable-motion.vim的作用能够使用鼠标滚动键顺滑地进行翻页
<C+u> <C+d> 的效果现在就是顺滑地翻页，注意力不会跟丢代码位置

## 动作语法
### 内置动作语法
dfa 光标向前跳到a字符之间的字符，并且删除包括a之间的内容
dFa 光标向后跳到a字符之间的字符，并且删除包括a之间的内容
dta 光标向前跳到a字符之间的字符，并且删除不包括a之间的内容
dTa 光标向后跳到a字符之间的字符，并且删除不包括a之间的内容
`!}column -t -s "|"` 在当前光标位置到段落结束之间，执行shell命令替换当前文档。`!` 号表示执行外部的shell命令，`}` 表示
范围是到段落结束，`column -t -s "|"` 表示要执行的shell命令
这段命令全部需要在normal模式下面输入才能正常工作。问题是由于没有回显，我们并不知道normal模式下输入的命令是否是正确的。
目前的一个方法是在shell终端上编辑好之后，再通过鼠标在vi的normal模式下一次给黏贴过去
另外一个方案则是使用set showcmd，此时当一个normal mode的命令没有完成执行前，在屏幕的右下角会有一个字符串显式你已经
输入过的字符串
当时目前vi是不支持编辑normal 模式下的命令的。所以最简单的方式是在其他地方先调试好，再一并输入进来
详细可以参考: https://github.com/iggredible/Learn-Vim/blob/master/ch04_vim_grammar.md

### easymotion插件增强vim动作语法
d <space> + e 后向删除到某个单词的结束，通过easy motion来定位具体的位置
d <space> + b 前向删除到某个单词的结束，通过easy motion来定位具体的位置
d <space> + j 后向删除都某行，通过easy motion来具体的位置
d <space> + k 前向删除都某行，通过easy motion来具体的位置
d <space>+ fa 往后删除从当前光标开始，到使用easy motion选定的字符a之间范围的字符串(包括a)。其含义是easy motion的动作
              是可以和文本对象结合进行使用的
d <space>+ Fa 往前删除从当前光标开始，到使用easy motion选定的字符a之间范围的字符串(包括a)。其含义是easy motion的动作
              是可以和文本对象结合进行使用的
d <space>+ ta 往后删除从当前光标开始，到使用easy motion选定的字符a之间范围的字符串(不包括a)。其含义是easy motion的动
              作是可以和文本对象结合进行使用的
d <space>+ Ta 往前删除从当前光标开始，到使用easy motion选定的字符a之间范围的字符串(不包括a)。其含义是easy motion的动
              作是可以和文本对象结合进行使用的
从上面的例子可以看出，easy motion除了支持s键以外，所以以 <space>开头的键，都是支持vi的默认动作的，比如f，F，t，a，w，b
间，也就是可以在vi的所有支持的动词加名词的动作中，都加入easy motion的支持。<space>+vim光标跳转键，除了扩展了vim的移动
光标的所有能力了，也极大加强了vim选择textobj的能力。这个动作键可以和vim中的所有编辑动作(d,c,s，以及插件所支持的编辑
动作)相互结合使用

## 文本对象
### 内置文本对象
diw 删除光标所在单词
ciw 修改光标所在单词
di(  删除括号内所有内容
d2i(  删除两层括号内所有内容，这个命令可以避免移动光标就可以进行编辑
ci(  修改括号内所有内容
da( 删除括号内所有内容，包括括号
ca( 修改括号内所有内容，包括括号
这里的( 也可以应用于 类似`{`, `"`, `'` 等标签，以及html标签
具体可见:

https://zhuanlan.zhihu.com/p/24387751

### vim-textobj-parameter插件
使用sgur/vim-textobj-parameter 插件来支持扩展text object的能力
https://github.com/wellle/targets.vim
扩展的能力其实不多：
1. 增加了dI( dA) 等大写的修饰符，与di， da的语义相类似主要用于处理 被选择内容与括号(或者是引号，csv等)间 空行的情况，
   具体见文档
2. 增加了n，l 修饰符，可以选择光标后，光标前的 pattern，不需要额外移动鼠标。比如 din（，在光标后面的( 中执行 di(
3. 支持 处理csv
di, 删除一个以, 分隔的csv中两个:之间的内容
di: 删除一个以: 分隔的csv中两个:之间的内容
4. 支持函数参数:
dia
daa 
删除函数的参数，i，a与di", da" 的含义类似

### vim-textobj-uri插件
使用 jceb/vim-textobj-uri 增加url text object
diu: 删除uri中的东西
dau: 删除uri中的东西

### vim-textobj-variable-segment插件
使用 jceb/vim-textobj-variable-segment 增加 变量名分段 text object
div: 删除一段变量名。变量名可以是下划线，或者是驼峰式的格式
dav: 删除一段变量名，包括下划线。变量名可以是下划线，或者是驼峰式的格式

### vim-textobj-indent插件
sfp13内置的插件  https://github.com/kana/vim-textobj-indent

能够按代码缩进来选择代码块。这个插件的主要用途是用于类似Python代码的选择处理
ii 选择与当前光标对应的行具有相同缩进的最小缩进块。即从光标所在的行，上下分别开始搜索所有缩进小于当前行缩进的行。
   当找到第一个空行，即停止
ai 选择与当前光标对应的行具有相同缩进的最大缩进块。即从光标所在的行，上下分别开始搜索所有缩进小于行缩进的行。

### vim-expand-region插件
https://github.com/terryma/vim-expand-region插件能够快速扩展当前文本对象范围
'+' 从当前光标位置扩大visual选择范围 
'-' 从当前光标位置减小visual选择范围 

### vim-textobj-comment插件
https://github.com/glts/vim-textobj-comment
这个插件添加了很实用的注释text-obj
用法：
dic 删除comment内部的内容
dac 删除整个comment的内容

### vim-textobj-space插件
https://github.com/saihoooooooo/vim-textobj-space
用法:
diS 删除所有连续的空格

### vim-texobj-entire插件
https://github.com/kana/vim-textobj-entire
用法:
vie 选择整个buffer中的东西。可以和NR, vim-tmux-runner一起使用

### git hunk文本对象: vim-gitgutter插件
vim-gitgutter提供了git hunk文本对象, 一个hunk指当前文档与git仓库中的一个差异
dic      textobj, 选择当前光标所在hunk并删除
dac      textobj, 选择当前光标所在hunk并删除

### 配对文本对象: vim-matchup插件
mathcup插件是matchit的加强版。主要好用的功能包括：
嵌套符号除了支持（）[] {} 等符号外，也支持语言的关键字
di%   删除嵌套括号或者语言关键字中的内容。不包括嵌套符。比起内置的di( , di{ 等text-obj，一方面需要记忆的符号更少，
      另外一方面支持语言关键字，是vim内置text-obj所不能比拟的。
d2i%  删除两层嵌套括号或者语言关键字中的内容。不包括嵌套符
da%   删除嵌套括号或者语言关键字中的内容。包括嵌套符

## 剪切板交互管理
### 拷贝系统剪切板到vim中:
ctrl + shift + v，具体可以参考下面链接 
https://askubuntu.com/questions/256782/how-to-copy-paste-contents-in-the-vi-editor
从系统缓存区拷贝到vim会出现缩进正常的问题。
可以通过命令:set paste 进入paste模式，先进行黏贴，
然后通过命令:set nopaste 退出paste模式
可以通过 unimpaired 插件的 [op 命令来缓解从系统缓冲区拷贝到vim中的多行数据不对齐的问题
出现这个问题的主要原因，是vim中对于来自keyboard的输入，都会默认打开自动indent的功能。而set paste的作用，也只是关闭
自动indent的功能而已。
此外，如果使用windows+alacritty的话，上面的操作会引起vim多插入分行。这是因为windows平台对于分行的处理存在问题
此时可以通过命令: Ap，然后输入ctrl + shift + v, 然后esc解决这个问题

### 从vi中选择文本到系统缓冲区
目前我们是打开了vi的mouse模式以及tmux的mouse模式，所以当我们使用鼠标在vi的buffer中进行选择时，默认是使用vi的visual模
式来选择文本。
当我们希望去选择文本到系统的clipboard时，按shilft键，同时使用鼠标在vi的buffer中进行选择，即可在secure_crt中将vi的
buffer中的数据拷贝到系统缓冲区中。 有时当我们做了tmux的分屏或者vi的分屏时，上面的工作方式会选择整行，因而不能正确
工作。此时我们通过 Alt+Shift加鼠标，可以选择一个矩形区域。这样子就在很大程度上缓解了分屏拷贝黏贴时的效率问题
另外一个方式就是将tmux，vi全屏，然后在将vim的number给关掉，在使用shift的方式来拷贝。有时当我们需要进行选择的文本在
tmux或者vi中跨了一行时 (但不是完整的一样)，适合采用这种方法。

### 名字/数字寄存器
可以通过名字寄存器，或者数据寄存器访问剪切板中最近访问过的内容。
数字寄存器存放的内容都是以行为单位的剪切内容
拥有这个功能，就意味着我们可以对剪切的内容进行精确的管理，从而能够对合适的剪切板内容进行粘贴。
比如说我们可以同时拷贝若干个不同的内容到不同的寄存器中，然后针对不同的情况，将寄存器中的内容给黏贴出来
数字寄存器是一个堆栈的结构，最新y，d的内容会存储在这些寄存器中。可以在visual mode上选择这些寄存器
"1p  将数据寄存器1中的内容给paste出来

对于名字寄存器，可以先在visual mode中对内容进行选定之后，输入: 进入命令模式，然后输入 yank a，将visual mode下选定的
内容给拷贝到a寄存器中
"ap  将名字寄存器a中的内容给paste出来
"ayiw 将光标所在单词拷贝到a寄存器中
名字寄存器的更多使用方案，可以参考下面的文章
http://vimcasts.org/episodes/using-vims-named-registers/

:registers 命令可以看到所有寄存器中的内容。
更多寄存器使用说明可以见
https://github.com/iggredible/Learn-Vim/blob/master/ch08_registers.md

### tmux clipboard集成:vim-tmux-clipboard插件
使用roxma/vim-tmux-clipboard 插件来将 tmux，vim的剪切板来打通
在tmux中copy的东西，在vim中通过在normal mode下键入 ""p 即可拷贝
在vi中y的东西，在tmux中ctrl + ]即可拷贝出来

### ring clipboard && 删除行为修正:vim-cutlass && vim-yoink插件
https://github.com/svermeulen/vim-yoink
https://github.com/svermeulen/vim-cutlass
vim默认的行为，是当进行d，x，s操作的时候，会将相应的内容拷贝到clipboard中
但是在绝大多数的场景下，这种行为都是错误的，导致需要使用clipboard的内容非常麻烦
为了解决这个问题 vim-cutlass 插件配置一个新的动作m，只有m的动作等价于原来的d操作
d、x、s操作都不会更改缓冲区
vim-yoink插件支持ring paste buffer，每次p后键入下面的命令，就会循环地获取paste buffer中的东西

命令:
<M+n> 获取上一个paste buffer的内容
<M+p> 获取下一个paste buffer的内容

## 避免重复操作
重复命令
. normal命令可以重复上一个输入的命令。这个命令可以大量缩减需要键入的键数量。比如说 de 删除第一个单词，然后 .就会再
  执行一次de
  又比如crc将单次变成了canmel case，然后移动到下一个需要处理的单词，再键入. , 则对应的单词也会变成 canmel case

宏
qa 开始录入vi的命令到寄存器a
q  结束录入宏
10@a 在光标当前位置重复a中的命令10次

## folding
zf 选定一段文本之后，添加一个fold，用于排除代码中不相关的信息，方便阅读代码
zd 删除fold
zD 递归删除fold
zo 打开被折叠的行
zc 关闭被折叠的行
za toggle被折叠的行
zR 打开所有被折叠的行
zM 关闭所有被折叠的行
zj 定位到下一个fold
zk 定位到上一个fold

https://github.com/iggredible/Learn-Vim/blob/master/ch17_fold.md

<leader>cfs 在当前文件 使用 set foldmethod=syntax 创建fold，适用于C++，golang这类文件, 或者希望fold行能被高亮的情况
<leader>cfi 在当前文件 使用 set foldmethod=indent 创建fold，适用于Python这类文件
<leader><leader>f  使用fzf进行folding搜索. 这个功能用于在MardDown文件中搜索title

## 书签
### 内置书签功能
书签: 用于在重要的代码中打标记，然后可以在不同的位置上方便地跳转阅读理解代码
mA 在当前光标所在位置打标签，并且命名为A。A是全局书签，可以跨多个不同的buffer
'A 去到A所在的位置
: marks  命令marks，用于输出当前的所有书签。
linux内置的书签功能太弱，因而目前使用了bookmark插件。

### vim-bookmark插件
应使用MattesGroeger/vim-bookmarks来替代vim自带的书签能力。
这是因为vim自带的书签能力太弱，甚至没有标签的展现，以及标签的内容标注，当内容较多是根本无法进行管理。并且没有对标签
进行持久化的能力
命令:
<leader>mi增加一个书签，并且对书签的内容进行标注
<leader>mc删除标签
<leader>ma列出全部的标签
<leader>mn跳到本文件下一个书签
<leader>np跳到本文件上一个书签
:BookmarkSave FILE_PATH 将书签存储备份到某个位置
:BookmarkLoad FILE_PATH 读入书签
当几个项目中的标签数据很多时，可以增加关键字来进行分组。这个插件已经与ctrl-p插件进行了集成，在进入ctrl-p中，
再按下ctrl-f，会见到标签的选择
此时就可以根据标签的特征来进行过滤，搜索

## 文件导航
### 目录树导航: nerdtree 插件
<C+e> toggle Nerdtree 作为文件树导航
在Nerdtree的窗口中输入?，会触发帮助。再输入?，帮助会消失
Nerdtree 输入o，会打开一个窗口buffer打开文件，并且不会关闭Nerdtree
Nerdtree 输入回车，会打开一个窗口buffer打开文件，并且会关闭Nerdtree
Nerdtree 输入i，会打开一个垂直分屏窗口buffer打开文件，并且不会关闭Nerdtree
Nerdtree 输入t，会按tab的方式打开一个窗口buffer
Nerdtree 输入m，会触发一个menu，上面有各种各样的文件操作可以选择
<leader>nt  以当前打开的buffer，打开nerdtree，并且将光标移动到nerdtree上。用于快速定位被打开文件相同目录/附近目录
            的文件。
<leader>tt  打开符号导航toolbar
在nerdtree中，选定了一个文件之后，在命令行输入BM(Bookmark命令)，则会创建这个文件的书签，并且能够输入文本进行标注
则在nerdtree的导航栏中，就会有BM的列表，其打开方式与普通文件的打开方式相同。BookMark的功能在于能够对于一系列相关的
文件给予快捷的访问方式
避免反复在文件中寻找代码位置。这种功能与vim-bookmarks一起，在阅读熟悉新的代码时，能够大幅减低大脑所需要承担的压力
在nerdtree中预览文件
在nerdtree中移动光标，按go，则光标不会移动到被打开的buffer中，可以用于在文件中进行预览

### 本地文件导航:vim-dirvish 插件
nerdtree更加适用与浏览整个项目的目录结构，而vim-dirvish则更加使用于浏览当前文件目录附近的文件。
一个典型的用法是在一个独立的窗口中 (:enew命令)，或者是一个split窗口中 (:vnew)，通过 vim-dirvish 来打开插件
vim-dirvish是netrw的替代品，但是更加强大。
其中的功能是vim-dirvish可以通过x键来选定对应的文件到arglist中。可以说是vim arglist的能力补全
此外最重要的功能，是vim-dirvish的buffer可以与普通vim buffer一样被编辑。比如通过d键来对buffer进行修改，或者使用shell等
命令进行filger，然后通过virtual选定需要的文件，键入.键来进行Shdo脚本允许。Shdo脚本与xargs类似，就是以 {} 符号作为占位
符执行shell命令,而每个占位符表示的则是被选中的文件。
这里需要注意的一个点，是使用'%'号获取当前执行的目录，否者很多shell命令执行的时候会提示找不到目录
比如需要对每个文件进行ls, 则输入的命令为  :Shdo ls -l %{} 。
这个功能就可以被看成一个交互式的shell脚本执行器, 而shell脚本的数据来源可以是通过vim buffer的操作方式得到的
比如说我们可以通过:%!grep 命令将需要处理的文件给搞出来
在选择好文件之后，我们就可以通过'.'键生成一个脚本。这个脚本会在一个新的窗口下被打开。
我们可以交互地对其进行修改。在完成之后, 在脚本窗口下执行 :%! bash, 即会在当前脚本窗口中显式命令执行结果.\
或者在shell buffer中输入mapping Z!执行命令, 并且退出shell buffer。
我们还可以对结果再进行编辑。这里实际演示了一种使用vim和bash进行交互的方式，即允许编辑器对bash命令执行的结果进行交互式
的编辑，然后再通过vim和shell之间的通信来交互执行命令。

这是一种我比较陌生的交互方式，但是实际上是个非常大的想法
这样子vim不仅仅可以看成一个源文件的编辑环境，同时也变成了一个交互命名的执行入口
就目前而言，这个命令只能交互式处理一个代码目录下的东西，但是也已经足够强大了

mapping:
-：在当前文件所在目录打开dirvish. 如果已经再dirvish中，则会跑到上级目录

在drivish buffer中的mapping:
g? : 显式命令帮助
gq : 返回启动drivish的文件
enter: 在当前buffer中打开dirvish选中文件, 或者进入子目录中
x: 将文件加入arglist
.: 将当前visual选定的文件加入Shdo脚本中进行执行
p: preview当前文件
<c-p>: preview curosr所在上一个文件
<c-n>: preview curosr所在下一个文件

在 drivish的shell buffer中的mapping:
Z! 执行当前脚本，并且退出shell buffer

命令行命令:
:Shdo ls -l {} 对于dirvish中visutal选中的行, 创建shell脚本, 命令为ls -l, 使用{}替代每一个选中的行
:Shdo! ls -l {} 对于dirvish中选中的agrlist, 创建shell脚本, 命令为ls -l, 使用{}arglist中的每个值

### 本地文件预览导航:ranger 插件
https://github.com/francoiscabrol/ranger.vim
<leader> + f即可在vim中启用ranger来寻找要打开的文件。从各个方面来讲都秒杀vim-dirvish插件。
所以在一般情况下需要在vim中寻找非项目中的文件时，直接使用这个插件打开ranger来访问即可

### 导航远程文件
在命令行中输入
`vim scp://<target_host>/<dest_dir>/`
或者先启动vim，再在命令下面输入:
`:e scp://<target_host>/<dest_dir>/`
则vim会启动netrw文件浏览器，浏览target_host下 dest_dir下面的内容。
这样子就可以解决远端机器上面因为没有合格版本的vim，编辑比较困难的问题。
在文件编辑过程中，若需要重新浏览文件，可以在命令中输入:
:Exp
启动netrw来对远程文件进行访问

### 符号列表导航:tagbar 插件
<leader> +tt 打开/关闭tagbar
这个插件需要安装 universal-ctags, tagbar插件需要对应的符号信息。注意tagbar会自动生成tags，不需要人为生成
sudo apt install universal-ctags

## 搜索
### 基础搜索
在本文件中搜索: shift+*, n , N，/ ，？
目前按 <esc> + <esc>, 或者unimpair插件的yoh命令，会取消找到目标的高亮

### 综合搜索:fzf.vim 插件
#### 安装
首先需要安装fzf，以及fzf默认官方的vim插件，然后才能安装fzf.vim
https://github.com/junegunn/fzf.vim

在 fzf 安装完成之后，在 .vimrc.bundles.local 中增加:
Bundle 'junegunn/fzf'
Bundle 'junegunn/fzf.vim'
在shell中执行:
vim +BundleInstall! +BundleClean +q

#### 功能
:Files filepath //搜索文件名，带预览功能。这个功能尝试过比ctrl-p要快得多。搜索任何东西的功能，都优先采用fzf来进行搜索
                //这个文件默认的搜索目录是在当前打开的buffer的目录下搜索文件
:GFiles  //与Files相同，但是可以支持在git项目的根目录下搜索文件。我们通常需要的就是这个功能
:Tags //全局搜符号
:BTags //在当前文件符号中搜索，带预览功能
:Lines //打开的文件中搜索行
:BLines //当前文件中搜索行
:Buffer //在打开的文件中搜索
:Maps //搜索vim的normal模式下的key binding
:Commands //搜索全部支持的命令
:Commits //搜索gitlog的提交历史
:BCommits //搜索gitlog的提交历史, 可以按文本区间进行搜索，非常强大
:Ag keyword   //在当前打开的文件目录搜索代码, 因为有预览窗口，所以比ack.vim要好用
:AG keyword //在git项目的根目录搜索代码, 因为有预览窗口，所以比ack.vim要好用
:History:  //搜索vim命令历史
:History   //搜索打开过的文件

在文件选项中执行ctrl+v，则会打开一个垂直分屏打开文件
在文件选项中执行ctrl+x，则会打开一个水平分屏打开文件
在文件选项中执行ctrl+t，则会打开一个tab打开文件

注意到当fzf提示有priview windwos时，可通过鼠标滚动，或者atl+j, atl+k来控制preview window所展现的内容

我们绑定了一些快捷键，用于快速触发fzf的功能
在任意模式下
<leader> tab 对不同模式下的mapping进行fzf搜索

<learder> Q 对QuickFix窗口进行搜索. 
<learder> L 对Location窗口搜索. 
<leader> :  对vim的命令历史进行fzf搜索
<leader> /  对vim的搜索历史进行fzf搜索
<leader> H  对vim的全局mru file进行fzf搜索
<leader> W  对vim的window进行fzf搜索
<leader> b  对vim的buffer进行fzf搜索, 主要用途打开无名窗口
<learder> Z 对folding搜索. 这个功能用于在MardDown文件中搜索title

在insert模式下
<c+x><c+f> 对当前输入的字符串为前缀的path进行fzf补全。能够补全任意的path
<c+x><c+r> 使用本地zsh的命令历史进行fzf补全。这个功能在编写bash脚本时尤其有用。因为很多命令都会现在终端上输入调试后
           ，才会编辑到shell脚本中
<c+x><c+k> 使用linux本地的词典进行fzf补全。最大的用途是避免忘了英文单词的拼写时，不需要离开终端就能找到你需要的东西
<c+x><c+l> 对当前输入的字符串为前缀的vim已经打开的文件行进行fzf补全。当需要跨文件去拷贝命令行时，这个命令可能会派上
           用场

### mru文件列表:fzf-mru.vim插件
https://github.com/xarronpan/fzf-mru.vim
这个插件实现了一个基于项目的mru。这正是开发项目代码所急需的
命令:
<leader>M  启动mru查找文件进行编辑
<leader>R  刷新mru列表，用于清理被删除的文件

注意若我们的项目跨了几个仓库的情况下，这个插件只搜索当前仓库下的mru，可能使用起来不方便
此时应该考虑fzf.vim的History命令。目前已经绑定了命令:
<leader>H

### 关键词高亮:vim-interestingwords插件
这个插件支持在阅读，review代码的时候，同时对n个不同的word进行高亮，秒杀vim内置的高亮功能
https://github.com/lfv89/vim-interestingwords
使用方式:
<leader> +k 高亮一个word
<leader> + K 取消全部的高亮

### grep搜索:ack插件
ACK keyword filepath
也同样可以通过AG来做。但是ACK命令的优势在于可以指定需要进行查找的文件目录 (这个目录是相对于项目的根目录的)
ack.vim 插件对应的搜索程序没有安装，需要手动安装：
sudo apt install silversearcher-ag
注意Ag，Ack等程序的搜索结果中会包括tags产生的文件，所以需要在项目目录下配置一个 .ignore 文件
.ignore文件中的内容写入:
tags
将生成的tag文件给排除在Ag，Ack的搜索结果之外

### 综合搜索:ctrlp插件
ctrlp最为重要的功能是mru搜索能力。在编写代码进行代码导航时，最为有用的就是这个功能。目前已经绑定了ctrl+k来进行导航
(fzf中不存在这样子的功能)
ctrlp中选择完成后打开一个垂直分屏, 使用 ctrl+v
ctrlp中选择完成后打开一个tab, 使用 ctrl+t
ctrlp切换搜索模式 ctrl+f，其中mru是most recent used文件的意思，用于寻找最近打开过的文件

## 文本替换
在文本中进行替换，一般是:s//命令

### subsitude预览
<leader>/  使用one-motion插件的能力，对subsitude命令结果进行预览，非常使用

### vim-far 插件
far插件可以认为是vim substitute命令的增强。其除了支持subsititute完整的正则表达式替换，替换表达式中\1 \2匹配括号的功
能外，最为主要的能力是
1) 做替换的预览，并且在预览窗口进行排除后，最后再做应用
2) 能够使用一条命令很方便地指定目录以及文件模式。而不需要使用vim arglist的方式来添加。
总的而言，far插件基本秒杀vim内置的替换功能
此外，far的正则表达式不需要\v前缀，就可以其从较为标准的extended posix regex的功能
https://github.com/brooth/far.vim

命令示例:
`:FAR word1 word2 %`  将当前buffer的word1 替换成 word2
`:FAR word1 word2 parent/*.cc`  在git的根目录中，将父级目录为parent的所有后缀为cc的文件中的word1 替换成 word2
`:FAR word1 word2 parent/ ` 在git的根目录中，将父级目录为parent的所有cc的文件中的word1 替换成 word2
`:FAR foo(.+) too\1 *.cc  ` 在git的根目录中，将 foo(.+) 正则表达式的pattern替换成 正则表达是括号中的内容
file pattern的说明可以看far的文档
https://github.com/brooth/far.vim/blob/master/doc/far.txt

在替换窗口中的快捷键：
t    toggle 选定行是否要被排除在替换之外。这个命令可以应用于visual所选择区域
zc   对文件进行fold
zo   对文件进行unfold   这里fold，unfold的命令实际上与普通的文本buffer操作没有差别
s    正式应用替换
u    undo 替换

### ctrlsf插件
ctrlsf会产生一个类似与sublime的查找输出，并且最为重要的功能，是能够在查找输出的窗口中进行文本编辑，替换，并且能够保存
适合于目的未完全明确的文本替换操作。在一次查找过程中，只有少量的文本会被替换掉
命令：
:CF pattern 启动ctrlsf进行替换操作
在搜索结果窗口中，p是preview结果
ctrl+j, ctrl+k  是在搜索结果中上移，下移

## 文本转换
### 括号配对编辑:surround插件
surround增强了括号的处理能力，其命令与文本对象的编辑能力很像，常用的包括
cs"' 成对将“修改为‘
ds" 成对删除"
ysiw" 在当前光标中增加“ 。这个功能可以结合easy motion，很容易对一段字符加括号，能解决输入括号时的痛苦。比如  foo|，
|为光标位置，则在normal模式下输入 ys<leader><leader>b<easy motion选择位置f>), 则文本将变成(foo)
 这是因为ys操作可以作用与所有的vim textobj上，而easy motion的<leader><leader>b键等价于带选择能力的vim b选定textobj
 功能，因而这两个能力是可以结合起来使用的。
vS" 首先触发visual模式 (v是普通的visual模式，V是行式的visual模式，都可以工作)，选定文本后按S，再按"，全部选中的内容
被" 扩起来
具体可见:
https://github.com/tpope/vim-surround

### 注释，反注释:nerdcommender插件
<leader>cc 对于选定的区域增加注释
<leader>cu 对于选定的区域反注释

### 多光标操作:multi visual插件
https://github.com/mg979/vim-visual-multi
mult visual是multi cursor插件的加强版，基本上秒杀multi cursor插件

选定文本:
<c-n>会以当前光标下面的文本为模本，进入multi visual模式，进行文本搜索。y有时<c-n>不一定能够选择得到合适的文本，
此时可以先进入visual模式选择需要转换的问题，再键入<c-n>, 则插件会以visual模式下选择的内容启动多光标替换
<c-n>有时需要进行处理的多光标模式不一定为相同模式的问题。此时可以通过<c-n>, 在输入/则能够通过类似正则表达试的方式
确定需要进行处理的多多光标文体。由此可见这个插件在需要批量进行文本替换时真的堪称神器

操作选定文本:
n 选定下一个光标，N 回退一个光标，q 跳过一个光标。当光标选定之后，就可以以普通的visusl模式下的编辑模式对文本进行编辑
按 <Tab>，则可以切换到一个类似与normal的模式。此时所有的vim的normal mode的多数命令都能够使用，比如说 adolish，
surrond的命令
移动光标之后再按tab，则会根据光标的位置，调整被进行visual选择的区域
按 i/a 等，则可以进入到插入模式
按入 \\x，则会进入ex模式，vim中的全部ex命令都能执行，并会对所有被选中的visual区域进行执行。
<c+方向键> 则会类似与列模式一样选定多行，并且进入normal模式进行编辑
按esc键将会退出multi visual模式

### 变量名转换:abolish插件
spf13中安装了 abolish插件，特别适用变量重命名, 比如说具有不同大小写/形式，但是含义相同的一组单词，需要重命名成另外一
组单词, 
以及变量形式变化，比如下标与驼峰式的名字的自动替换
变量重命名例子:
:S/facilit{y,ies}/building{,s}/g   保持大小写的形式，将facility变成building, 并且通过 y->无，ies->s 的映射来处理单
                                   数复数的形式映射

变量形式转换例子:
crs： 转成下划线形式
crm: 转成首字母大写形式
crc: 转成驼峰形式，与crm相同，只是首字母小写
cru: 转成大写形式
cr-: 与crs相同，但是单次以-相连
此外还支持单次间以 . <space>相连的功能，只是一般写代码的时候用不上
目前这个功能只支持在当期光标所在单词上面执行。若需要在多个不同的单词上面执行，则需要visual-multi插件的支持
另外这个插件还支持相似词的替换功能，当有较为复杂的相似词要替换时，普通的正则表达式也不一定能够简单地工作，
此时使用该替换功能能够简单工作
具体可以参考
https://github.com/tpope/vim-abolish

### 参数位置交换: sideways.vim
atl+h 尝试向左交换光标所在参数。
atl+l 尝试向右交换光标所在参数。

除了函数参数，这个插件也支持一系列的其他参数的位置交换，比如golang list参数等

### 交换文本: vim-exchange 插件
使用tommcdo/vim-exchange插件来交换对象
https://github.com/tommcdo/vim-exchange
cxx 交换两行。首先在第一行中键入cxx，然后再另外一行中键入cxx，则两行会被交换
X 在visual模式下进行交换。 首先使用visual模式对于第一个对象进行选择，并且按入X。然后在对第二个对象使用visual模式进行
选择，并且按入X。则两个对象会被交换
cx(textobj), 比如cxiw。现在在第一个文本对象中输入cxtextobj1，然后移动到另外对象中，输入cxtextobj2，则两个对象会交换

### 移动文本: vim-move 插件
注意下面的key是大写的
<A-J> 上移一块visual模式选定的文本
<A-K> 下移一块visual模式选定的文本

## 代码格式
### 缩进提示
缩进提示: <leader>ig

### 自动缩进
自动代码对齐: 使用visual模式选定文本之后，按 = 即可
选定文本后，采用< >可以减少，增加缩进。排版时使用这个键比采用列模式要来得方便
http://yyq123.blogspot.com/2010/10/vim-indent.html

### 按操作符对齐:tabular插件
按 = 号，: 号对齐
假设需要按=号进行对齐，则visual模式下选定需要对齐的文本，然后输入
:Tab /=
具体详见:
http://vimcasts.org/episodes/aligning-text-with-tabular-vim/


## 编辑
### 基础命令
列编辑模式: https://blog.csdn.net/scaleqiao/article/details/46289447
ctrl+v 进如列编辑选定模式，选定列，然后
删除列: d，列插入字符:  I，然后输入每列都要插入的内容，最后 Esc
insert mode下，
<C+h> 可以删除一个字符 (使用backspace的话效率较低)
<C+w> 可以删除一个词
<C+u> 可以删除一整行
具体可以参考下面的教程
https://github.com/iggredible/Learn-Vim/blob/master/ch06_insert_mode.md
u: undo
ctrl+r : redo

### 输入自动配对括号:autopair插件
autopair: 随便按一个 括号，进入配对模式。然后按 括号的结束符，结束配对
按一个括号进入配对模式后，按 space，再输入字符，则自动括号两边自动对齐。然后按 括号的结束符，结束配对
https://github.com/jiangmiao/auto-pairs

## 正则表达式
vim默认搜索命令/ , 替换命令s// 所使用的正则表达式与Perl标准的正则表达式标准不同。有些字符与正则的元字符相同，
有些又不相同，所以很难使用
为了解决这个问题，在进行使用正则时，统一增加一个\v前缀，则会与其他语言的正则保持一致

## git集成
### gui集成:fugitive插件
:Gcd 是当前命令执行的当前目录变成git的根目录
  这个功能是fugitive插件提供的最重要的功能之一。因为很多的命令都是基于文本当前的buffer所在目录作为相对目录进行执行的。
  Gcd用于将这些命令的目录转移到git根目录，也就是通常所说的项目根目录下，因而会更加有用
  比如：
:Gcd | Ack 在git更目录下执行Ack命令，对代码在项目根目录下的代码进行搜索
:Gcd | Far 在git更目录下执行Far命令，对代码在项目根目录下的代码进行搜索和替换

:G 触发 fugative
 g? 键 help
 s: 键  执行git add
 u: 键  执行git reset
 dv: 对选定的文件启动垂直分屏的gdiff
     在冲突合并的场景下，对冲突文件使用dv会触发3方merge, 能够非常清楚地显示冲突情况

:G diff [git diff命令的所有参数] 触发图形化的对比

:G log [git log命令的所有参数] 触发图形化的log修改浏览
 o 新建窗口查看 commit的diff
 p preview commit的diff

:G blame 查看文件每一行是哪个版本引入的
 o 新建窗口查看 commit的diff
 p preview commit的diff

:G rebase -i 在vim中触发git rebase -i, 用于调整commit历史

:G! push 异步push到仓库
    !号表示在后台的意思。此时会启动一个preview window来暂时命令执行的进度
    这个规则也可以使用在其他G命令中

### gitdiff集成: vim-gitgutter
vim-gitgutter能够在sigcolum上显示正在提交的代码与git仓库中的差异，并且能够处理这些差异
每一块差异称为一个hunk
<leader> hs stage当前光标所在的hunk
<leader> hu undo当前光标所在的hunk
<leader> hp 在preview window中展现当前hunk的git diff
]c       跳转到下一个hunk
[c       跳转到上一个hunk

vim-gitgutter提供了git hunk文本对象, 具体参考文本对象一章

### conflict处理: conflict-marker
https://github.com/rhysd/conflict-marker.vim
[x      跳转到上个冲突
]x      跳转到下一个冲突
co      采用ours分支的代码
ct      采用theirs分支的代码
cb      同时采用两者分支的代码
cB      同时采用两者分支的代码, 采用相反的顺序
cn      两者都不采用

### fzf
GC      使用fzf查看/搜索Git commits
GBC     使用fzf查看/搜索当前Buffer的Git commits
        可以选定一个文本区间，查看这个文件区间
        在什么commits中被修改过

## 命令
### 行命令
d 命令:
可以删除一行。这个命令可以在global命令中，结合pattern过滤能力使用，就变得非常强大
j 命令：
可以将多行文本变成一行文本。
用法，使用visual模式选择多行文本，然后在命令中输入: j，即可将多行文本变成一行文本
sort 命令:
可以排序多行
用法，使用visual模式选择多行文本，然后在命令中输入: sort，即可排序多行文本
m 命令:
将某一行移动到某个address。比如说m 0表示将行移动到第一行中，m $表示将行移动到最后一行中
这个命令可以用于对行进行revert，对内容进行提取等处理
t(co) 命令:
将某一行拷贝到某个address。比如说c 0表示将行拷贝到第一行中，c $表示将行拷贝到最后一行中
这个命令可以用于对行进行提取等处理
a/i 命令:
在搜索到的行的上面/后面增加一行字符

address在vim中的定义，可以通过在vim中输入:h address得到。该帮助所显示的内容，也同样适合于gloal命令中pattern

### 外部命令
vim中的外部执行命令，是可以与shell的命令打通的。其拥有将行数据给予外部命令处理完成后，再修改当前行的能力
vim命令能力的本质优势是可编程，几乎可以无限扩展。但是代价是前期的入门成本比较高
:r !date   //执行date，并且将date的结果输入当前行。!号表示启动外部命令，而r是vim中内置的读入命令，能够读入文件。
           //两者组合，表示将date的输出读入到当前行中
:w !cat    //读入全部的文本数据，并且调用cat执行命令
:.!grep -oP '\d+\.\d+\.\d+\.\d+'    //读入当前行(.表示当前行)，并且将当前行作为STDIN送给grep命令，然后再获取grep
                                    //命令的输出替换当前行的内容
:% !grep -oP '\d+\.\d+\.\d+\.\d+'  //读入当前文件所有行(%表示所有行)，并且将每一行作为STDIN送给grep命令，然后再获取
                                   //grep命令的输出替换每一行
具体可以参考下面的教程
https://github.com/iggredible/Learn-Vim/blob/master/ch14_external_commands.md

### global命令

vi的global 命令是来自于ed命令的。所以vi中的s命令，全局命令范围匹配的语法定义，都是与sed是相类似。
注意到vim中的i，a，c等命令的命名方式就是来源于ed编辑器的，所以sed中也存在这些命令。不过这些命令是作用在一整行上的
目前看起来vim作用与行的命令种类要比sed中的要多。更准确地说，vi比sed多了光标移动, 以及基于光标的文本动作的文本处理
能力，而sed的处理能力，基本上只能基于一整行来进行

global command可以通过一个 g/pattern1/,/pattern2/的模式选定 pattern1, pattern2之间范围的文本来进行处理。这个选定范围
的能力与sed的范围选定能力定义是相同的。
并且能够指定与pattern1，pattern2之间的行偏移。模式的具体定义，可以通过在vim输入 :h address的文档中得到详细的描述
外部命令，以及类似s的命令，都是直接可以与global command进行集成的。
global command本质上是一个多行的文本过滤以及处理能力。这样子行上面的任何命令都可以在行数据上进行处理，本质上就是给予
了无限的扩充能力 
g/mongodb/.!grep -oP '\d+\.\d+\.\d+\.\d+'                     //在有mongodb的当行中，将行中内容作为STDIN调用外部命令
                                                              //grep，将行中的ip地址给过滤出来后，再替换当前行的内容
g/mongodb/s/mongodb/hello/g                                       //在有mongodb的当行中，执行 s/mongodb/hello/g操作，
                                                                  //将行中所有的mongodb都变成hello
其中行处理能力中还涉及多行的处理函数比如sort，j命令等。
global command的详细介绍可以参考下面的文档:
https://github.com/iggredible/Learn-Vim/blob/master/ch13_the_global_command.md

### 异步命令+quickfix集成: asyncrun.vim插件
使用 skywind3000/asyncrun.vim 将quick-fix window与外部命令进行集成
常用命令: AR youcommand

### 修正命令执行目录:rooter插件
https://github.com/airblade/vim-rooter
这个插件非常重要，提供了改变被执行命令当前执行目录的能力。
用户可以自定义项目根目录的特征。
这个命令特别与很多搜索命令是绝配。
命令：
: PR | Files   在项目根目录下执行fzf的Files命令

### tmux集成:vim-tmux-runner插件
https://github.com/christoomey/vim-tmux-runner
这个插件主要的功能在于在vim中不需要失去focus，就能在vi的窗口下创建一个tmux pane，执行shell 命令
这种命令的主要用途是用于调试脚本. 我们可以在另外tmux窗口中打开类似python的命令行，然后在vim本地编辑完之后
将需要进行调试的代码行给发送到python命令行中进行调试。此这种编程方式称为REPL
外, 在我们在vim中进行编辑，需要输入一些信息，而这些信息的来源需要通过命令行才能获得时, 也可以通过这种方式来获取
所以这个命令的典型用途是与 tmux-bulter插件一起使用。目前只要 <prefix> + v，就能启动pane输出历史的补齐功能。
所以这种场景下，vim就能够很容易获得需要输入的内容
（如果需要输入进来的是多行的话，还是只能通过r！等方式来调用命令，大家所擅长的使用场景不同）
:TR command 将command发往tmux runner窗口
:TRL        将编辑器所在行，或者visual区域中的命令发送到tmux runner窗口中
:TA         将当前已经被打开的tmux窗口作为tmux runner窗口
例子:
:TR ls -l

## IDE功能
### youcompleteme 插件
#### 安装
首先安装YouCompleteMe插件
在spf13 的 .vimrc.before.local 配置中增加 bundle group: youcompleteme，并且将 neocomplete 给干掉
bundle group是spf13中定义的bundle组的概念，当选定一个组时，会有若干个插件也被进行安装。
在spf13中，若将neocomplete干掉，激活youcompleteme，则在 .vimrc.before.local 进行如下配置 :
let g:spf13_bundle_groups \
=['general', 'writing', 'programming', 'php', 'ruby', 'python', 'javascript', 'html', 'misc', 'youcompleteme', ]
在vim的命令行中执行 :BundleInstall!
安装时间较长，需要耐心等待
详细情况参考 https://github.com/spf13/spf13-vim 中YouCompleteMe插件的安装说明即可

上面的命令，会将youcomplete从git上clone到.vim/bundle目录下。
然后编译YouCompleteMe插件
cd ~/.vim/bundle/YouCompleteMe

依照youcompleteme官方文档https://github.com/ycm-core/YouCompleteMe#installation 中youcompleteme linux 64bit的说明进
行安装:
sudo apt install build-essential cmake vim-nox python3-dev
sudo apt install mono-complete golang nodejs default-jdk npm

cd ~/.vim/bundle/YouCompleteMe
sudo python3 install.py --all

上面的命令会安装所有ycm支持的语言的自动补全。

在vim中输入命令:
:YcmDebugInfo
确认youcompleteme已经安装成功

#### 功能
快捷键:
注：<leader>键按上面的配置，是 '，' 号
tab: 在有语法提示的时候，进行提示的选择
shift+tab: 反方向在语法提示中进行选择
这两个按键使用于对语法提示进行选择时手不需要离开键盘的主区，是建议的使用方式

<leader>d 若对应的程序行上有语法错误，显示语法错误细节

在.vimrc.local 中增加与 ide快捷键配置:
ctrl+z 强行启动ycm的语义补全。一般ycm的语义补全只有在 -> .等操作后面才会启动。
nnoremap <leader>gd :YcmCompleter GoTo<CR>                               //普通的跳转功能
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>:q<CR>:copen<CR>     //反向查找引用功能。由于ycm默认没有打开
                                                                         //quicklist窗口，所以需要在调用了Ycm的命令后
                                                                         //之前试过gotorefernce vim直接退出的问题，
                                                                         //怀疑是ycm找不到目录中的其他文件引起的。
                                                                         //此时只要将nerdtree插件给调用出来，再进行
                                                                         //跳转即可。目前这个问题复现不了，暂时不清楚
                                                                         //原因
                                                                         //再显式地将ycm的窗口关闭，再调用copen命令打
                                                                         //开quicklist窗口，方便在quicklist窗口中浏览
                                                                         //所有的语句引用
nnoremap <leader>fi :YcmCompleter FixIt<CR>                              //自动修正编译错误
nnoremap <leader>gi :YcmCompleter GoToImplementation<CR>                 //跳转到接口实现功能
nnoremap <leader>doc :YcmCompleter GetDoc<CR>                            //显示符号文档信息, 按esc键之后，显示符号的窗
                                                                         //口不会关闭

实用命令：
：lopen                                                                  //打开location list。ycm会将出错代码汇总位
                                                                         //置都放在location list中
: cn //GoToReference功能会将结果方案quick fix window中。cn用于访问quick fix window的下一条
: cp //GoToReference功能会将结果方案quick fix window中。cp用于访问quick fix window的下一条
:YcmCompleter GoToSymbol '目标符号'                                       //全局查找符号
:YcmDebugInfo                                                             //ycm调试输出

<leader>pt                                                                //在preview window中打印光标下面符号的代码定义
<leader>pc                                                                //关闭preview windows
<leader>et                                                                //打印光标下面符号的类型信息

#### 编译数据库
youcompleteme会使得vim变成一个真正的集成开发环境。在编辑c/c++项目时，为了使得clang能够工作，如果是使用make的项目，
需要安装compiledb来生成编译数据库
https://pypi.org/project/compiledb/
同时为了头文件也可以正确编译, 还需要安装compdb，生成头文件的编译代码信息, 否则遇到存.h文件时, 会报编译错误
https://github.com/Sarcasm/compdb
这样子youcompleteme就可以进行错误的实时提示，以及进行精确的符号跳转，符号查找

### vim-go 插件
#### 安装
spf13的配置中默认已经安装了vim-go插件。需要在 .vim.before.local 中显式配置 bundle_groups, 增加go的组，然后在运行 
vim +BundleInstall +BundleClean，
才会真正安装vim-go插件。
在安装完成vim-go插件后，需要通过gvm安装合适版本的golang，再打开对应的项目，并在
在命令行中运行：
:GoInstallBinaries
则会将vim-go所需要的运行时库给下载下来。在完成之后，vim-go才算安装完成。
这个插件的很多功能，其实在ycm中已经包括了。所以这类功能直接使用ycm中的能力即可 (都是基于gopls的，所以普通的代码导航
能力实际上是没有差别的)。
在安装完成gvm之后，使用 gvm use goversion 命令设置 GO_ROOT等变量，并且通过go get等命令将依赖的包给下载回来之后，
ycm就可以启动自动补全以及语法实时提示的功能了
(在启动的时候，最好显式在启动vim的终端中键入命令: gvm use go{yourversion})

#### 功能
<leader> god   输出当前类型的描述信息，包括了函数等相关信息
<leader> goi    输出当前类型所实现的接口

自动生成代码的命令：
`:GoImpl [receiver] [interface]`
根据 receiver 与 interface生成golang的stub代码
例子:
`:GoImpl f *Foo io.Writer`
生成类型为Foo，函数参数为f，实现接口 Foo io.Writer 的桩代码

代码自动lint，fmt的命令：
注：
guru中包括了很多动态分析的代码分析能力，比如GoCallees，GoCallers等。这些能力因为非常消耗分析资源，因为guru需要设置
一个scope之后才能进行分析使用
此外，只要引用的库代码中有使用cgo的话，则不能正常进行编译，所以这类动态分析的功能目前基本不可用。
而且guru官方已经不会再继续进行更新，全都替换成了gopls。所以这些功能都避免去使用即可。使用全局的代码搜索，其实也能很
快将这些东西给分析出来

### 代码模板: ultisnips 插件
 spf13中已经安装了ultisnips 以及 ultisnap 的snippet仓库。当我们数据的字符串中包括了 snippet的关键字时，ycm的菜单中就
 会给出带有 <snip> 字样的提示
在选中该菜单之后，在输入 ctrl + j，则会将snapit的文本加载到代码编辑器中。
通过 ctrl+j ctrl+k 可以在snapit的不同参数中移动，编写需要的逻辑

snapit的定义可以在: ~/.vim/bundle/vim-snippets/UltiSnips 目录中找到，上面可以学习到已经默认定义了哪些snippet。
更多的说明可以学习:
https://vimzijun.net/2016/10/30/ultisnip/

在vi中输入: UltiSnipsEdit，即可在一个编辑窗口中编辑自动以的snips

### 生成桩代码: vim-gencode-cpp 插件
使用vim-gencode-cpp插件，通过头文件的定义，自动生成cpp文件中的函数定义
以及通过cpp文件中的函数定义，自动生成头文件中的声明，避免很多重复体力劳动
<leader><leader> gi 通过函数声明生成函数定义stub. 需要将光标放置在函数上, 再按这个快捷键 
<leader><leader> gd 通过函数定位生成header的定义函数. 需要将光标放置在函数上, 再按这个快捷键 

### AnyJump
当LSP无法编译当前文件时, AnyJump使用正则表达式的方法给出最好的go to defination
和 go to reference的能力。这点可以和Tags的能力一起使用, 对LSP IDE的能力进行补充
<leader>j 启动AnyJump界面

## 缩写
当我们通过abbrev命令定义了缩写之后，在vim的命令模式下输入缩写的命令，都会被vim自动展开
比如使用搜索命令时，若搜索关键字与缩写相同，则搜索关键字会被展开。这可能不是我们所希望的行为
这时候只要键入ctrl+v, 则vim便不会启动缩写的展开

## tags管理
 使用ludovicchabant/vim-gutentags自动生成和管理ctags
 这个插件需要安装 universal-ctags, tagbar插件需要对应的符号信息。注意tagbar会自动生成tags，不需要人为生成
 sudo apt install universal-ctags

## 文档生成
使用vim-scripts/DoxygenToolkit.vim 来增加对c/c++/python生成doxygen风格文档的功能
命令:
   在函数行中输入名: Dox即可生成文档

## 效率插件
### h/c/cpp/cc文件快速切换:a.vim插件
使用vim-scripts/a.vim ，支持在头文件与源文件之间快速切换，打开窗口进行编辑
常用命令:
:A      在头文件，目标文件间跳转
:AV     以vertical split打开头文件，目标文件，方便同时进行编辑
具体可见
https://github.com/vim-scripts/a.vim


### 补充命令:vim-unimpaired插件
使用 tpope/vim-unimpaired 插件，就不用在记住一堆的成对的命令
[op （或者 [op 以及 yop命令）然后进行 黏贴，则退出insert模式之后，会自动退出paste模式。不再需要麻烦的set paste，
set nopaste
yon toggle set number
yol toggle set list
yoh toggle 搜索高亮
[q next quickfix item
]q prev quickfix item
]l next locationlist item
]l prev locationlist item
由于命令较多，可以通过: h unimpaired 命令来查看所有的东西。一般而言，如果发现成对的命令，可以实现unimpaired的模式，
看是否能够工作。
尽可能少地手动输入命令。太慢了。

### 符号配对:vim-matchup插件
mathcup插件是matchit的加强版。主要好用的功能包括：
嵌套符号除了支持（）[] {} 等符号外，也支持语言的关键字
% 跳到配对的嵌套符号
[% 往外跳出当前的嵌套括号。跳掉嵌套括号的开始
[2% 往外跳出两层当前的嵌套括号。跳掉嵌套括号的开始
]% 往外跳出当前的嵌套括号。跳掉嵌套括号的结束

matchup提供了match up文本对象，具体参考文本对象一章

### 翻译:vim-translator插件
直接可以在编辑器中，遇到不认识的单词直接启动翻译，而不需要到浏览器中进行操作，加快工作流程
https://github.com/voldikss/vim-translator
命令：
TL  可以在normal模式或者在visual模式下执行。会在status line中给出翻译信息。目前只有英文到中文的翻译运行得比较稳定

### 草稿窗口:scratch.vim 插件
这个插件用于启动一个草稿窗口
草稿窗口可以用于存放临时需要进行记录的内容。这点在编写需要反复进行拷贝黏贴的代码时特别有用。虽然这个功能也可以通过
拷贝寄存器来实现，
但是草稿窗口中的内容还是可以进行进一步编辑的。
这个窗口还可以进行一些草稿记录，比如记录当前需要完成的事情等等
一个典型的应用场景: 编写C++代码的时候，子类想要从一个或者多个父类那边拷贝一些virtual函数来进行重新实现
但是一个个地将这些函数从父类拷贝到子类中，需要反反复复在父类和子类之间拷贝黏贴代码
此时我们可以使用scracth buffer，先在一个父类中，将需要重新实现的virtual函数，通过visual+gs的方式给拷贝到
scratch buffer中，搞完了之后，再一次性地将全部的需要拷贝的函数给通过scratch buffer拷贝到子类中
这样子就降低了每个需要拷贝的函数都要去找父类需要进行编辑的脑力负担
还是上面的例子，假设我们需要到很多个地方去收集代码，然后做拷贝黏贴
我们可以先将需要定位的位置给放到scratch buffer, 这样子就不需要反反复复去寻找这些这些需要收集代码的地方
比如说需要从一个子类的父类中找实现的函数进行实现。我们可以先将子类的父类列表放到scratch buffer中
这样子我们就可以跳到父类中，而不需要保持子类的窗口打开，而不知道下一个需要搜索收集的东西是什么东西

其本质上可以看成一个可加工的paste缓冲区来进行使用

命令：
:SW  启用sratch窗口
<leader>sw 启用scratch窗口
<leader>sp previewscratch窗口
normal mode下按入gs ， 则会进入sratch窗口并进入insert模式。当退出insert模式的时候，窗口会自动关闭
visual mode下按入gs， 则会将visual的内容拷贝进入sratch窗口，并且进入到sratch窗口中。
任意模式下键入gS，则会清空sratch窗口的内容
目前只要离开scratch buffer的窗口，scratch buffer会自动关闭

### 限定区域编辑:NrrwRgn插件
https://github.com/chrisbra/NrrwRgn
采用这个插件，可以保证修改只发生在被选定的区域
这个功能的一个主要用途是向对一段文本使用vim中的命令进行替换，但是不希望这些替换在区域之外生效
此时就可以使用这个功能，在一个独立的buffer中进行修改
使用方式
使用visual方式选定一段区域，然后输入命令 : NR


## diff
### diff目录:vim-dir-diff插件
采用这个插件就可以直接在命令行下，对代码进行递归diff，类似与beyond compare
https://github.com/will133/vim-dirdiff
目前已经在shell中进行了配置，可以通过 dirdiff dir1 dir2 来启动对比

### diff选定行:linediff插件
linediff插件可以完成以前出现过的对比两段代码的功能。
使用方式：
在第一段文本使用visual方式选定后，输入命令：DL
在第一段文本使用visual方式选定后，再输入命令：DL
则此时就会启动vim diff窗口进行对比
https://github.com/AndrewRadev/linediff.vim

### diff buffer
在一个window上打开多个文件
:DB Diff同一个window上多个文件
:UDB 关闭同一个window上多个文件Diff
<c+w> c: 关闭diff窗口，显示原来的窗口

### delta
<leader><leader> ds  使用delta显示当前buffer的内容(通常是fugative中diff输出). <c-w>_可以全屏观察delta的内容
<leader><leader> dv  使用delta -s(竖式)显示当前buffer的内容(通常是fugative中diff输出). <c-w>_可以全屏观察delta的内容

## Doc
###doge 插件
doge插件可以生成各种形式的函数文档。
注意该插件使用之前，需要在 .vim/bundle/vim-doge/scripts 目录下执行install.sh
Mapping:
<leader><leader>dg gen document
<Tab> 下一个文档项
<S-Tab> 上一个文本项

## MarkDown
<leader><leader>t 打开Toc窗口进行Markdown导航
## Man
]] [[ 跳到下一个，前一个章节
K 根据光标所在链接跳转
C-T 跳回刚才的地方
g/ 启动options搜索. 比如搜索 g/-Werror
gf 根据光标所在文件跳转

## help
normal mode下面键入K，能够以当前光标单词为key去搜索vim的help文档。在阅读vimrc的时候，就不需要反复到web页面上去阅读
插件的文档。
