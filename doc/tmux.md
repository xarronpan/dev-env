# 配置
如果机器上的tmux版本低于2.5，则toggle全屏的功能不能正常使用，需要手动进行安装
安装tmux 2.5
https://gist.github.com/indrayam/ebf53ba970241694865e1dd2b1313945

在 .tmux.conf 的插件定义行后，插件run行前增加下面的配置:
set-window-option -g mode-keys vi
这样子在输入 ctrl-a + enter之后，就可以采用vi的操作方式在屏幕上面移动，并且可以使用 / 在屏幕上支持搜索。这种使用方式
主要是在屏幕的输出log中寻找内容
注意按securecrt目前的keybinding的设置(使用emac的方式来使用alt键)，tmux的alt键是不能工作的，遇到使用atl键的插件，应该
采用调整alt键的方式来工作。

启动mouse模式
在.tmux.conf 中增加下面一行：
set -g mouse on
或者按照下述文档的方式，即可通过mouse来对tmux的pannel进行选择
https://blog.csdn.net/ddydavie/article/details/79031564

# 功能
目前的prefix为 ctrl+a

## pane/窗口/session 管理
### 内置功能
prefix + : 输入命令 new，创建新tmux session
prefix + C +c  创建新tmux session
prefix + d  从当前tmux session dettach
prefix + w 切换session/window. 在界面中选中会话/window/panel，按x能够删除对应对象
prefix + s 切换session. 选中session按h，l键能够展开/收起 会话/window/panel
prefix + $ 重命名当前session
关闭session，可以使用tmux fzf插件的菜单功能来关闭
prefix + c 在当前session中创建窗口
prefix + & 关闭当期窗口
prefix + o 切换到下个pane
prefix + （hjkl）上下左右切换pane
prefix + （HJKL）上下左右拉伸pane。可以通过这种快捷键，临时隐藏暂时不想使用的pane，从而使得一个window中的pane的数目
                 更多，协作更加紧密
prefix + enter 进入到vi-copy-mode
prefix + p paste选择到的内容到命令行中
prefix + num 切换窗口
prefix + ,  重命名窗口
prefix + - 垂直分窗口，创建新pane, panel与当前panel在同一个目录中
prefix + _ 水平分窗口，创建新pane, panel与当前panel在同一个目录中
prefix + % 垂直分窗口，创建新pane
prefix + " 水平分窗口，创建新pane
prefix + x 关闭当前pane
prefix + ！ 使用当前pane创建新窗口

### 会话管理: tmuxinator
会话的概念相当于一个tmux项目的概念。一个tmux的项目中，应该有多个关联关系相对较紧密的多个不同窗口。而一个窗口中的pane，
则应该是内容更加紧密的
我们可以通过更加强大的插件，来将session中的布局给持久化下来，变成一套完整的ide环境配置。在涉及到的ide项目结构非常复杂
的情况下，或者项目非常多的时候，就需要tmux的session管理工具来完成这些事情。
tmuxn new project  创建一个新project, 并进行编辑配置
tmuxn ls           查看项目列表
tmuxn start project 使用一个新的tmux sesison启动项目
tmuxn edit project  编辑项目配置
tmuxn copy src_pro dest_pro 使用src_pro的配置，创建dest_pro

配置的使用非常简单, 详细可见:
https://github.com/tmuxinator/tmuxinator

### 并行会话交互: xpanes
可以用于同时打开多个tmux pane，执行参数化的命令，或者同时输入相同的命令
在多台机器上面同时跟踪日志的时候特别有用, 例如:
```bash
xpanes --ssh 10.27.0.100 10.27.0.110 10.27.0.117 10.27.0.122    #打开n个pane，ssh到多台机器上，
                                                                #并且多个pane中输入的命令是相同的。输入的命令是交互式的
xpanes -ct 'ssh {} tail -f /data/services/cim_fanout_pdc-t02221606.b6b0cd17.r/log/pdc.log' \
10.27.0.100 10.27.0.110 10.27.0.117 10.27.0.122 #打开n个pane，并且执行-c中的命令
```
注意到当我们全屏其中一个窗口时，输入的命令是不同同步到其他机器中的。
这就使得这个工具既能实现多台机器间输入的命令同步，也能使得有时有些机器上面的命令不同于其他命令
这就意味着这个工具的工作流，就是先打开一堆需要可能进行操作的机器，然后在逐个进行操作，再看是否有需要一起进行操作的内容。

### 设置多个pane sync输入
sync输入能够保证打开的pane的输入命令是一致的。这点在查找分析日志时很有用
prefix + ' 打开pane sync
prefix + " 关闭pane sync

### 菜单式管理: tmux-fzf插件
sainnhe/tmux-fzf
这个插件的主要作用有三：
* 查询tmux的keymapping，有点像在vim中用fzf来查询Maps中功能
* 复杂的pane，window，session操作。
   *比如杀死一个session，使用tmux fzf插件就非常方便
   *又比如将一个pane给合并到一个windows中去，使用pane下面的join命令即可
* 从tmux的copy缓冲区中，通过fzf的方式将copy的文本给paste到命令行中。因为一个复杂的运维操作中，有大量的命令输入的内容
  其实都是来自于之前的缓冲区的，所以这个功能实际上是非常实用的, 能够大幅减低自己copy paste的重复劳动
目前的启动命令是: <prefix> + t

## 剪切板交互/管理
### 从终端中选择文本到系统缓冲区
目前我们是打开了tmux的mouse模式以及tmux的mouse模式，所以当我们使用鼠标在tmux的buffer中进行选择时，默认是使用tmux的visual
模式来选择文本。当我们希望去选择文本到系统的clipboard时，按shilft键，同时按住鼠标左键可以在tmux的终端窗体中进行选择，
并在secure_crt中将. tmux终端窗体中的内容拷贝到系统缓冲区中。 鼠标的双击可以直接选定一个单词，但是选定不了ip，地址或者文件
路径。按主shift，再按鼠标的右键，则会将对应的内容拷贝到相应的输出中。
有时当我们做了tmux的分屏或者vi的分屏时，上面的工作方式会选择整行，因而不能正确工作。此时我们通过 Alt+Shift加鼠标，
就可以选择一个矩形区域。这样子就在很大程度上缓解了分屏拷贝黏贴时的效率问题
另外一个方式就是将tmux，vi全屏，然后在将vim的number给关掉，在使用shift的方式来拷贝。有时当我们需要进行选择的文本在tmux或
者vi中跨了一行时 (但不是完整的一样)，适合采用这种方法。
此外在tmux的mouse模式下，不按住shift键，则默认会使用tmux的visual模式来选择文本。此时在切换到vi中后，可以直接通过 ""p将内
容拷贝到vi中。在tmux窗口中，可以通过ctrl+p拷贝到命令行中。
这种copy方式的优势在于在命令行中可以跨一屏，跨split窗口进拷贝。

## 从屏幕输出获取信息
在vi-copy-mode中，/是启动查找，v是开始选择，y是完成选择
### 拷贝选定文本: tmux-yank插件
https://github.com/tmux-plugins/tmux-yank
tmux-yank的主要功能是在屏幕上进行copy选定之后，按Y即可将copy的内容paste到当前命令行中。可以当做是命令行补全来进行使用。
这个插件可以与tmux-jump与copy-cat插件一起工作

### 同panel屏幕信息获取插件 tmux-copy-toolkit插件
https://github.com/xarronpan/tmux-copy-toolkit
tmux-copy-toolkit集成了tmux-jump, tmux-finger 还有vim easymotion的能力。是目前已知的tmux上在单pannel上获取信息最强的插件
其有几种不同获取pannel内信息的方法, 见下面的描述.
命令:
prefex + . 获取屏幕上符合预设pattern的字符串, 并输出到prompt的位置中.输入n可以切换下一批匹配模式
prefex + > 获取屏幕上符合预设pattern的字符串, 但是不输出到prompt, 只拷贝到tmux的buffer中.输入n可以切换下一批匹配模式

prefex + f 使用类似easy-motion的方式, 分别选择start + end的模式拷贝一段字符串. 拷贝到的内容输出到prompt的位置
prefex + F 使用类似easy-motion的方式, 分别选择start + end的模式拷贝一段字符串. 但是不输出到prompt,只拷贝到tmux的buffer中

在进入tmux copy mode之后，输入s，就可以进入类似vim easy-motion的方式移动光标
在选择到一个光标之后，输入v开始select文本，此时再输入s, 就可以通过easy-motion的方式选择范围
copy-mode下:
s easy-motion 通过字母移动光标
Sj easy-motion 向下选择行开始位置
Sk easy-motion 向上选择行开始位置
Sn easy-motion 选择行开始位置

### 跨panel已知模式文本auto-complete: tmux-bulter插件
https://github.com/woodstok/tmux-butler
命令:
prefix + space  将当前session中所有window一段历史区域的内容作为补全内容进行选择
prefix + ;  将当前window一段历史区域的内容作为补全内容进行选择

prefix + space 进入使用当前tmux上的屏幕输出，使用fzf来进行选择后，并且进行输出补全。在进入补全之后，还可以通过alt+pattern的
方式，选择需要进行补全的pattern。内置的模式包括ip，命令行输入，hash等模式
这个插件与tmux-finger与tmux-jump不同最为厉害的地方，是能够将一个windows上全部panne的内容都给进行收集。
基于这个插件的强大性，若需要进行补全的内容是跨pane的，则应该使用这个插件进行补全 (比动用鼠标的速度可能还是要稍微快一些)
一种经典的使用场景，就是在vim中写入东西，然后需要从pane的另外一端将内容给输入到文本之中。另外一端的文本可能是在另外一台
机器上的数据。
这个插件允许你以任何可以想象的方式都能工作。而且因为是基于tmux的，所以根本不受服务器上shell的限制

这个命令目前的主要问题是不会将内容拷贝到tmux的缓冲区中。所以若是考虑作为copy paste而使用的话则不合适
这个插件最最为厉害的另外一个地方，就等于是一个tmux命令补全的框架，与fzf-vim的vim补全框架相类似，你可以将任何你能够想到的
东西，都塞到tmux-bulter中。
比如说tmux-bulter默认只能补全panel中能够visible的部分。其实只要对READER参数进行一些调整，则很容易我们能够创建一个能够获取
当前session全部window文本的数据源，
从而补全功能就等于能够支持已经滚屏跳过的内容 (只是此时由于候选的内容太多，反而补全的效果不一定会好)。所以bulter所提供的补
全能力，理论上说是无限的。

### 总结
在希望从终端中copy参数到命令行时，首先应该使用finger，然后是tmux-jumper，然后是tmux-butler, 最后是鼠标的方式来进行选择
在经过tmux-finger, tmux-jump, tmux-butler, tmux-yank的配置之后，其实只有需要拷贝到windows下面进行处理的东西，才需要使用
鼠标来进行拷贝 (鼠标进行拷贝的速度其实是较慢的)

## 屏幕内容搜索
### 同panel 正则表达式搜索: copycat插件
https://github.com/tmux-plugins/tmux-copycat
由于有 tmux-finger，tmux-jump等插件，copy-cat存在的理由只有是支持正则表达式搜索，以及需要进行拷贝的内容已经不在可视范围
内，但是具有较为复杂的内置pattern，比如ip，地址，文件路径，hash等。
只有在需要在命令内容中进行正则搜索时，或者待搜索内容不可视，且待搜索内容具有相对复杂的模式，比如说ip，地址，文件路径，
hash等，才考虑使用copycat插件
有用的快捷键定义
prefix + ctrl-f - simple file search
prefix + ctrl-h - jumping over SHA-1/SHA-256 hashes (best used after git log command)
prefix + ctrl-u - url search (http, ftp and git urls)
prefix + ctrl-d - number search (mnemonic d, as digit)
prefix + ctrl-i - ip address search

### 同panel fuzzy搜索: tmux-fuzzback插件
https://github.com/roosta/tmux-fuzzback
这个小众插件可以将pane中的buffer作为fzf的输入源。
当我们在远端机器上进行操作是，可能会输出log，也有可能会ls出命令的结果，但是由于内容过长了导致看不到结果
以前的方法是翻屏去看结果，但是还是有点累。此时可以使用这个插件，直接交互式地观察屏幕上面的输出结果。
就等于是命名行输出上的grep命令，能够实时查看功能结果，还是非常实用的。
<prefix> + ? 可以触发这个插件的功能

## snippet
### 命令片段模板: tmux-pet插件
https://github.com/haru-ake/tmux-pet
https://github.com/knqyf263/pet
tmux-pet是pet snappet管理程序的tmux封装程序。这个轻量级的程序的主要用途是记录命令行的片段。
tmux对pet程序进行封装的主要用途，是能够允许在任何机器上，都能调出snappet来对命令片段进行调出。当我们积累了足够多的snappet
的时候，这个功能就会变成一个强大的功能。
我们就不再需要对很多的命令记录手册，而只需要通过快捷键将snappet给调用出来使用。
pet支持按参数模板来填入参数，而且这个插件能够与tmux-bulder等插件一起工作，能力就更加强大了。pet还支持对命令加标签，
能够增加找到代码片段的效率
目前该功能的主要用途:
  记录alias
  记录经常使用的，但是较难以输入的命令
  记录功能强大、不常用的，但是难以输入的命令
若其他命令cheatsheet都用的功能, 并且不太成为瓶颈的, 则没有必要在这里记录。
比如说vim的mapping之类的。这样子可以节省不少工作量

目前配置的启动快捷键：
prefix + e   进行命令搜索
prefix + E   进行tag搜索. 因为命令很多, 需要通过tag来精确地匹配搜索
             该命令的结果需要输入到pet上
```bash
pet new  #增加snappet
pet edit #管理snappet
pet sync #将snappet同步到gist进行备份：
pet exec #选择snappet
```
在gist token失效的时候(目前可能token有一个过期时间，大多数情况下不需要进行token刷新)，需要刷新分配个pet的gist token，
pet sync的时候token才能正常工作
请在上面的链接中刷新token
https://github.com/settings/tokens
刷新token之后，再通过pet config命令跟新pet 配置文件中的token字段

### 临时数据存储: tmux-butler插件
tmux-bulter插件中包含了一个sneppetdb用于存储临时数据。典型的数据比如 机房的名字与机房id的对应关系，某个app的appid的值等
经常要用到作为输入，但是不是典型的命令片段的情况
prefix + v 会启用sneppetdb中的内容，通过key将内容获取到命令行中。snippetdb相对于pet而言非常轻量，更加适合于存储一些与
业务相关联，但是反复需要作为命令参数的输入源要用到的数据
比如所机房的groupid，某个业务的appid等信息。这个插件也能够大大加快进行编程，运维操作时的大脑负担，因为要获取这些业务数据
通常很繁琐
```bash
sa key value  #在snippetdb中增加key value对
sr            #通过fzf选择需要删除的key value对
```
## 自动补全
### 使用文件浏览器补全文件名: ranger集成
当输入一个命令时需要一个文件或者目录作为参数，而这个参数你并不记得具体的名称，更加希望通过file explorer的方式来找到文件，
此时可以通过键入<prefix> + a，选择ranger选项启用，选择文件或者目录，最后在ranger中键入Q，然后获取到对应的文件或者目录作为参数
这个命令在进行dirdiff，或者在vim键入命令时，需要文件参数时特别有用，能够大幅降低大脑的负担

### 使用ansible inventory补全ip/group: ansible-inventory集成
当输入一个命令时需要一个ip作为参数时，可以通过键入
<prefix> + a，选择ansilbe-hosts或者ansible-groups选项, 可以通过选择ansbile的inventory来选择对应的ip地址来进行处理。
在选择groupid时，可以通过tab进行多选，此时的含义是多个groupid求交集得到的ip地址。该功能对于复杂的inventory结果特别有用
在选择hosts时，可以通过tab进行多选，c-t 来toggle全选。
为了使该系统能够知道系统中所存在的inventory，需要在 $HOME/.inventory目录中建立各个不同的inventory目录的软连接
每一项软连接称之为一个环境。在使用ansible-inventory进行集成时，首选会选择环境参数
与此相类似地，当需要一个ansible-group作为参数时，可以通过键入

### 使用tmux-buffer进行补全: tmux-butler插件
tmux-bulter插件内置集成了使用tmux-buffer作为补全内容源的功能
prefix + b 会使用tmux的clipborad中的内容进行补全。这个功能直接可以提到tmux-fzf的clipboard补全功能。因而tmux-fzf的
clipboard快捷键的功能太深了

## 插件管理
安装tmux插件管理器
https://github.com/tmux-plugins/tpm
可以从命令行中直接触发插件安装，删除。
https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md

## 文档集成
### cheatsheet集成
<prefix> + m   启动cheatsheet, 查找有用信息
### notes集成
<prefix> + n   启动notes，查找有用信息
### manpage集成
<prefix> + q   启动manpage，查找有用信息

## 翻译: tmux-google-translate插件 
https://github.com/knakayama/tmux-google-translate
这个插件，在加入 <prefix> + X之后就会启动 translate-shell进行翻译
默认会将中文翻译成英文。要启用中文到英文的翻译，需要在shell中输入 :zh
在tmux的vi-copy-mode下面，选择好了单次之后，再键入 X，即可调出插件进行翻译
有了这个插件之后，在终端之中遇到不懂的单词，再也不需要到浏览器中找相关的内容，能够加快阅读资料的速度

## trzsz
在tmux中支持rz sz, 方便文件传输
trz/rz 从windows下载文件到终端
tsz/sz 从终端上传文件到windows上
注意这项功能能工作, 需要在windows terminal中安装tssh，并且在tmux机器上安装trzsz
