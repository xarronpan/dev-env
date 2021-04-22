tldr

https://github.com/tldr-pages/tldr

高质量的unix command man page。对于一个unix 命令，可以先参考这里的说明，再翻阅man page，再考虑google

tldr的特点是给出来的信息质量高，按使用频率来进行排序，不求全面

cheat.sh的特点是比较全面，但是命令较多，适合用于进行搜索



cheet.sh

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

比如：cd go  进入go语言查询分类，然后 

           revert list 查询如何 revert list的相关结果

           revert list/1 获取这个查询命题的下一个结果 

           这里每一项结果都是一个可用的代码级，因而可能需要浏览多个结果之后才能找到合适的答案

           :learn 则能给出当前编程语言的一个简单速查表



cht中本身也集成了相当数量类似与tldr的命令使用例子。

比如 ： find  输出一系列常用的find命令的使用例子。cht中的命名cheat的数量，复杂度比tldr中的要稍高一些，对于高级用户更为有用

所以在tldr中若没有找到满意的答案后，可以使用cht进一步进行尝试，看能否找到答案



rlwrap

使得任何从stdlin行中获取命令的工具，都能拥有像shell那样子的能够通过上下键寻找曾经输入过的命令，并且进行编辑的能力



fzf

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



fasd

https://github.com/clvv/fasd

一个用于访问mru文件，目录的工具。有了这个工具之后，就不需要反反复复cd来改变目录了

alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection
除了能够通过z来cd进入最近使用的目录外，与autojump这类项目不同，fasd还支持直接将 mru 文件，目录当作参数传给其他命令。比如 vim `f dev`。

并且支持交互式的选择能力。比如sd， sf，zz命令。

s命令则用于list mru cache的使用情况



ag

在本地上面搜索代码时，应该使用ag替代grep。因为ap的速度比grep要快非常多



fdfind

https://github.com/sharkdp/fd

一个速度比find快100倍，命令行参数要简单70%的find命令，比find要好用太多了



parallel

可以方便地在命令行中并行地在本机或者远端执行命令

这个命令牛逼的地方是可以以很短的命令行，地将需要处理的命令分发到不同的机器上，在处理完成之后再传输到本地

就是一个迷你的并行处理工具。

https://opensource.com/article/18/5/gnu-parallel

https://www.youtube.com/watch?v=OpaiGYxkSuQ&list=PL284C9FF2488BC6D1



socat

netcat的增强版，主要的功能就是数据流的双向转发，中转能力。

该命令可以认为是ssh端口转发功能一类的命令，主要的功能是解决网络环境的限制问题

http://www.dest-unreach.org/socat/

比如：

socat TCP-LISTEN:80,fork TCP:www.example.com:80

将本地的80端口的数据转发到 www.example.com:80 中去

这个工具非常强大，甚至可以实现复杂的NAT转发映射功能 (在外网启用一个listen 端口，然后通过一个中转服务器，中转到内网机器上，也就几行命令)。

具体可以见:

https://www.hi-linux.com/posts/61543.html

这个工具的强大还远不止如此。所有的本地文件，readline等输入都可以看成socat所能进行转发的东西，因而这个工具可以说是无比强大的。

socat甚至支持将进程命令的输入输出与数据包管道进行相连，因而能够组合出无比强大的网络环境

相对而言，netcat没有转发数据到一个进程中的多个端口之间的能力，因而能力上只是socat的一个子集。



axel，aria2 

wget的加强版，支持多线程下载，断点续传。当网络状态不好时，wget下载不了的东西，可以通过axel来进行替换



bat

在只读源代码时，可以使用bat替代less。因为bat命令中支持语法的高亮显示。bat命令可以用于解释命令 --help的输出，比less的可读性要好上很多



delta

可以用于对diff的输出结果，进行可视化展现。可以进行配置的格式非常多样

使用方法: 

diff -uZ  A.file B.file|delta

diff -uZ  A.file B.file|delta -s

diff -ruZ dir1 dir2|delta -s

diff -ruZ dir1 dir2|delta -s

git diff | delta -s



xpanes

可以用于同时打开多个tmux pane，执行参数化的命令，或者同时输入相同的命令

在多台机器上面同时跟踪日志的时候特别有用:

xpanes --ssh 10.27.0.100 10.27.0.110 10.27.0.117 10.27.0.122  //打开n个pane，ssh到多台机器上，并且多个pane中输入的命令是相同的。输入的命令是交互式的

xpanes -ct 'ssh {} tail -f /data/services/cim_fanout_pdc-t02221606.b6b0cd17.r/log/pdc.log' 10.27.0.100 10.27.0.110 10.27.0.117 10.27.0.122  //打开n个pane，并且执行-c中的命令

注意到当我们全屏其中一个窗口时，输入的命令是不同同步到其他机器中的。

这就使得这个工具既能实现多台机器间输入的命令同步，也能使得有时有些机器上面的命令不同于其他命令

这就意味着这个工具的工作流，就是先打开一堆需要可能进行操作的机器，然后在逐个进行操作，再看是否有需要一起进行操作的内容。



fpp

https://github.com/facebook/PathPicker

用于直接在shell脚本的输出中获取文件名，并且执行相关命令

9 csplit

可以通过正则模式来将文件拆分成几个独立的文件

有用的例子

https://www.golinuxcloud.com/csplit-split-command-examples-linux-unix/#1_csplit_based_on_regex_match

10 paste

paste命令是cut命令的反操作，可以将多个文件按列或者按行进行合并

https://www.howtoforge.com/linux-paste-command/

11 join

join命令与数据的join的含义是相同的，只是使用在文本记录上面。需要在文本有一个键将记录给串联起来

有用的例子

https://shapeshed.com/unix-join/

7 检查.so所依赖的动态库

使用objdump命令。依赖的动态库可以在 Dynamic Section 一部分中被找到

objdump -p exe

...
Dynamic Section:
...


translate shell

https://github.com/soimort/translate-shell

用于直接在命令行中进行内容翻译，不需要到浏览器中进行，加快工作速度

