# 文档
## tldr
https://github.com/tldr-pages/tldr
高质量的unix command man page。对于一个unix 命令，可以先参考这里的说明，再翻阅man page，再考虑google
tldr的特点是给出来的信息质量高，按使用频率来进行排序，不求全面
cheat.sh的特点是比较全面，但是命令较多，适合用于进行搜索 

## cheet.sh
https://github.com/chubin/cheat.sh
其杀手应用是部分替换stack overflow，尤其是编程语言领域中，要做某些事情的解决方案
tldr，以及超级速查表cheetsheet针对固定的问题使用效率更高，而cheat.sh的主要作用是能够找到开放式问题的答案
而相对于使用google + stack overflow 使用这个工具进行查询效率更高。因为给出来都是基本能够使用的代码片段
因而在google + stackoverflow之前，先用这个工具快速检索是否存在问题的答案，针对性会更高
安装cht.sh客户端，能够带来较好的使用体验

cht.sh安装完成后，在
.bash_aliases 中增加
alias cht='cht.sh --shell'

cht命令来快速查找需要的编程语言 问答答案
在终端中，支持的命令包括:
:list 列出全部的目录分类。一般一个目录是一门语言
:intro 给出cht最重要的功能介绍
help 列出帮助
cd go  进入go语言查询分类，然后 
           :list 则能给出当前编程语言的一个速查表的目录。输入list的内容即可找到对应的速查内容
           :learn 则能给出当前编程语言的一个简单速查表
           :learn~keyword 当给出的速查表过大时，可以通过~keyword，只展现与keyword匹配的功能
                          比如 tar~extract 只展现tar命令cheatsheet中extract相关的内容 
           1line 该语言中常用的一行代码 (:list的结果中可以获取到)
           weirdness 该语言中一些奇怪的行为 (:list的结果中可以获取到）
           如果内置cheat sheet不能满足要求，则可以使用开放的语句在stackover flow上进行查询
           revert list 查询如何 revert list的相关结果
           revert list/1 获取这个查询命题的下一个结果 
           这里每一项结果都是一个可用的代码级，因而可能需要浏览多个结果之后才能找到合适的答案

cht中本身也集成了相当数量类似与tldr的命令使用例子。
比如 ： find  输出一系列常用的find命令的使用例子。cht中的命名cheat的数量，复杂度比tldr中的要稍高一些，对于高级用户更为有用
所以在tldr中若没有找到满意的答案后，可以使用cht进一步进行尝试，看能否找到答案

## info
info page是加强版本的manpage，解决了man page没有结构化的章节, 以及手册内容难以理解的问题.
man page更加多是一个类似与一个全面介绍工具系统功能的cheatsheet, 更加适用于在阅读完命令的例子之后，进入深入了解系统的详细功能
而info page则更加适合于系统地全新学习一个命令
info page使用的时候需要配置vi-key binding才相对比较容易进行使用.
当info page缺失时, 比如tar命令，会fall back为man page.此时在ubuntu上需要安装命令所对应的文件包 xxx-doc
以tar为例子，则命令为: sudo apt install tar-doc
在设置了vim的key mapping之后, 在info中的重要命令如下:
H      显示info的help page，里面有详细的key mapping说明。第一页中的key mapping是最为重要和基础的
`M-g`    跳转到链接所在的页面
'      跳转回到上一个页面
`M-<`    跳转在当前页的顶部
`M->`    跳转在当前页的尾部

在当前页面中，可以使用vi的key mapping进行移动，以及进行页面搜索

# 交互增强
## 综合搜索工具: fzf
https://github.com/junegunn/fzf
几乎全部的需要手动输入的内容，都可以通过这个工具进行获取
比如获取文件里面的行，某个名字的进程id，获取网络端口号等。因为是交互式的，而且是fuzzy的，所以我们很容易就能调整发现我们需要查找的内容是否是正确的。
最重要的功能是替换bash里面的自动补全功能
比如 ctrl-t能够更好地替换bash里面的文件自动补齐功能
ctrl-r能够提供一个更好的搜索命令历史的功能
ctrl-j ctrl-k，上线翻动选定的行
alt-j alt-k  , 滚动预览窗口

这个工具的另外一个主要用途是可以用于创建很多好用的交互式脚本。
项目集合在下面的地址中
https://github.com/junegunn/fzf/wiki/Related-projects

比较有用工具:
https://github.com/junegunn/fzf.vim    进一步增强vim中的能力。主要是vim的多数能力都能进行fuzzy搜索。搜索Tags以及本文件Tags，搜索本文件内容，vim Maps的能力都很好用
https://github.com/denisidoro/navi      cheet的搜索增强能力
https://github.com/bigH/git-fuzzy        git命令行的增强能力。这个项目本身也挺有用的，但是由于fugitive已经完成了git中绝大多数命令行管理的功能，所以这个工具本省意义不大
https://github.com/laktak/extrakto       tmux能力增强。看起来很炫酷，但是不支持跨pane的屏幕数据的拷贝黏贴，所以实际用于比较有限。

## 文件浏览工具: ranger
命令:
:Q 在rg命令中，cd到对应的目录中. 在tmux/vim插件中，将选中的目录/文件作为参数进行输出
:z 在ranger中使用fastd进行跳转

快捷键:
ctrl-h: toggle show hidden files
alt-f: 在rg中启用fzf进行搜索

此外ranger支持很多插件功能，能够让其能力更加强悍
https://github.com/ranger/ranger/wiki/Custom-Commands

## rlwrap
使得任何从stdlin行中获取命令的工具，都能拥有像shell那样子的能够通过上下键寻找曾经输入过的命令，并且进行编辑的能力


# 网络工具
## 网络包转发: socat
netcat的增强版，主要的功能就是数据流的双向转发，中转能力。
该命令可以认为是ssh端口转发功能一类的命令，主要的功能是解决网络环境的限制问题
http://www.dest-unreach.org/socat/
比如：
```bash
socat TCP-LISTEN:80,fork TCP:www.example.com:80```
将本地的80端口的数据转发到 www.example.com:80 中去
这个工具非常强大，甚至可以实现复杂的NAT转发映射功能 (在外网启用一个listen 端口，然后通过一个中转服务器，中转到内网机器上，也就几行命令)。
具体可以见:
https://www.hi-linux.com/posts/61543.html
这个工具的强大还远不止如此。所有的本地文件，readline等输入都可以看成socat所能进行转发的东西，因而这个工具可以说是无比强大的。
socat甚至支持将进程命令的输入输出与数据包管道进行相连，因而能够组合出无比强大的网络环境
相对而言，netcat没有转发数据到一个进程中的多个端口之间的能力，因而能力上只是socat的一个子集。

## 数据下载增强: axel，aria2 
wget的加强版，支持多线程下载，断点续传。当网络状态不好时，wget下载不了的东西，可以通过axel来进行替换

# 基础工具增强
## 语法高亮版本cat: bat
在只读源代码时，可以使用bat替代less。因为bat命令中支持语法的高亮显示。bat命令可以用于解释命令 --help的输出，比less的可读性要好上很多

## 高可读diff: delta
可以用于对diff的输出结果，进行可视化展现。可以进行配置的格式非常多样
使用方法: 
```bash
diff -uZ  A.file B.file|delta
diff -uZ  A.file B.file|delta -s
diff -ruZ dir1 dir2|delta -s
diff -ruZ dir1 dir2|delta -s
git diff | delta -s
```
## mru目录跳转: fasd
https://github.com/clvv/fasd
一个用于访问mru文件，目录的工具。有了这个工具之后，就不需要反反复复cd来改变目录了
```bash
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection```
除了能够通过z来cd进入最近使用的目录外，与autojump这类项目不同，fasd还支持直接将 mru 文件，目录当作参数传给其他命令。比如 vim `f dev`。
并且支持交互式的选择能力。比如sd， sf，zz命令。
s命令则用于list mru cache的使用情况

## 代码搜索: ag
在本地上面搜索代码时，应该使用ag替代grep。因为ap的速度比grep要快非常多

## 搜索文件: fdfind
https://github.com/sharkdp/fd
一个速度比find快100倍，命令行参数要简单70%的find命令，比find要好用太多了

# 文本处理
## 按模式拆分文件: csplit
可以通过正则模式来将文件拆分成几个独立的文件
有用的例子
https://www.golinuxcloud.com/csplit-split-command-examples-linux-unix/#1_csplit_based_on_regex_match

## 按列或行合并: paste
paste命令是cut命令的反操作，可以将多个文件按列或者按行进行合并
https://www.howtoforge.com/linux-paste-command/

## 文本元组join: join
join命令与数据的join的含义是相同的，只是使用在文本记录上面。需要在文本有一个键将记录给串联起来
有用的例子
https://shapeshed.com/unix-join/

## 使用sql对文本进行处理: q
q 命令可以对csv格式的内容进行SQL处理，包括类似于filter，groupby, 甚至对文件进行join的能力是其他工具需要编写较多的代码才能实现的
有用的例子
http://harelba.github.io/q/#installation

## datetime处理
dateutil工具包提供了dgrep, dseq, dsort等对datetime进行处理的工具包，对于时间相关的处理非常顺手
有用的例子:
http://www.fresse.org/dateutils/

# 并行处理
## parallel
可以方便地在命令行中并行地在本机或者远端执行命令
这个命令牛逼的地方是可以以很短的命令行，地将需要处理的命令分发到不同的机器上，在处理完成之后再传输到本地
就是一个迷你的并行处理工具。
paralled提供的命令行能力基本上与xargs是相同的。所以基本上xargs能够进行使用的地方，就可以使用paralled命令，但是paralled的并行化能力
比xargs要强, 同时处理能力也更加灵活。比如说-n(--max-args)参数在xargs中与paralled中都能够从标准输入中最多读入n行作为需要执行的命令的参数1..n
但是paralled提供了引用n个不同参数占位符的能力，举个例子，{1}，{2}，...{n}
paralled中也提供了从命令行读取参数, 并且对参数进行的组合能力: 
paralled echo ::: 1 2 3 ::: 4 5 6               输入参数组合: 1 4,1 5,1 6,2 4,2 5,2 6 ..
paralled --link echo ::: 1 2 3 ::: 4 5 6        输入参数join: 1 4,2 5,3 6 ..
上诉这些功能在xargs中都是没有进行提供的

具体可以参考下面的资料:
https://linux.cn/article-9718-1.html
https://www.baeldung.com/linux/processing-commands-in-parallel
https://www.gnu.org/software/parallel/parallel_tutorial.html

# 编译工具链
## 检查.so所依赖的动态库: objdump
使用objdump命令。依赖的动态库可以在 Dynamic Section 一部分中被找到

objdump -p exe

...
Dynamic Section:
...

# 抓包
## tcpdump
tcmpdump存储的格式为pcap文件格式。由于wireshark也是基于pcap的，所以抓下来的包可以被wireshart进行分析
经典的使用方法是在服务器上使用tcmpdump抓包之后，再在wireshark进行可视化的图形分析
tcpdump的使用方式为:
tcpdump options pcap-expression
比较有用的options有:
-i any 从全部的接口进行抓包
-w test.cap 将文件给存储在 test.cap中. 
pcap-expression的作用是对数据包进行过滤，使用了pcap软件中所定义的包过滤规则。
一条过滤规则由  实体类型(比如说host port) 方向(比如说 src来源，dst目标) 协议(比如说tcp udp协议) 几部分组成，
而这些过滤规则本身可以使用and or 括号进行组合
man pcap-filter中见到详细的说明
具体可以参考下面的资料
https://www.cnblogs.com/wongbingming/p/13212306.html

