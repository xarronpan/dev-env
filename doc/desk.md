# secure crt
## 安装
安装secure crt 8.7版本

## 配置
### 颜色
终端属性中，Terminal/Apperance 的color scheme 选择 solarized dark颜色
Terminal/Emulator 选择 xterm，选择 256 color，这样子从服务器发送给securecrt的信息流中的颜色，字号信息(这些信息的术语就是ANSI color)，才能被secure crt解释到
Terminal/Emulator 中勾选 use color scheme，则securt crt会将收到的ANSI color信息与color scheme进行一些映射之后，再会显式在终端上。

### 鼠标滚动事件同步到远端
SessionOptions→Terminal 中，勾选Send Scroll Event to remote，这样子vim还有tmux才能响应鼠标滚动事件，并且进行屏幕的滚动

### alter键
Terminal/Enulator/Emacs， 选择Use ALT as Meta key，选择Send Escape for meta key。
这样子在bash终端上，就可以直接使用alt键来在bash中进行移动
注意到这样子的配置，意味着alt键在vi上是不能直接进行使用的。这是因为vim认识的alt键是另外一个终端命令 (8bit)的模式。
在vi上面使用meta键，需要做一些特殊的remap。所以，在vi中，并不推荐使用meta键作为快捷键。目前我们通过在vim中进行一些配置，来将这种alt键的信号转成meta键。所以vim中也是支持alt键的功能的。

## 常用功能 
### 打开浏览器来浏览屏幕中的url
这样子终端上面也可以访问类似网页的东西
按键: ctl + 鼠标左键，点击url即可

# xshell
## 安装
安装xshell7 个人免费版

## 配置
### 颜色/字体
导入solarized dark配色方案
工具->配色方案->导入
将dev-env/windows/solarized-dark.xcs在window中进行保存, 并且导入到xshell中

文件->当前会话属性->外观 
配色方案使用  solarized dark
加粗字体选择  使用大胆的色彩
使用闪烁的光标 光标闪烁设置 700ms

### 配置键盘
alt键
文件->当前会话属性->终端->键盘->Meta键盘仿真 
勾选: 将左alt键作为meta键, 将右alt键作为meta键

鼠标
工具->选项->鼠标和键盘
配置鼠标右键为 拷贝剪切板内容
鼠标中间为 弹出菜单
勾选 使用URL超链接, 勾选使用ctrl+单击 打开超链接
不勾选 使用ctrl+单击移动终端光标
在选择一项中, 勾选 将选中自动拷贝到剪切板

鼠标的滚轮事件不需配置默认就会发送到终端上,能够实现vim,tmux的滚动操作

键盘
工具->选项->鼠标和键盘
在按键对应  一项中点编辑按钮, 新建 ctrl+shift+v 快捷键, 并且选择快捷键类型为 菜单, 再选择菜单功能 (编辑)黏贴
将ctrl+shift+v键绑定成拷贝剪切板内容,保持与securecrt的使用习惯的一致性

新建 shift+space 快捷键，并且选择快捷键类型为 菜单，在选择菜单功能 (使用默认搜索引擎进行搜索)
这样子我们就将 shift+space绑定成启动搜索引擎的快捷键。

### 配置搜索引擎
工具-> 再网上搜索-> 管理搜索引擎中，可以填入搜索引擎的访问模板
google的访问模板为:
https://www.google.com/search?q=%s

### 配置X11 forwarding
安装xming，然后在 文件->当前绘画属性->连接->SSH->隧道
X11转移，勾选转移到XDISPLAY

### 常用功能
在经过配置之后,快捷键与securecrt完全相同.在tmux中使用shift + 相关鼠标快捷键即可完成相关功能
当我们使用shift+鼠标选定好了文本之后，
再按shift+space就可以将选择的文本作为关键字通过搜索引擎进行搜索

# alacritty
目前alcritty主要发现的问题有:
在windows中鼠标不能正常支持
在windows中黏贴多行文本的时候，会插入空行
在windows中编辑中文文件的时候，会出现奇怪的闪烁
综合而言，alacritty更加适合在linux平台上进行使用，而在windows中，更加适合直接使用windows terminal
除非所windows10版本不足导致windows terminal不能被安装

# windows terminal
在settings.json中，调整solarized dark的background值为#001E27
黏贴功能给remap成ctrl + shift + v

快捷键:
ctrl+shift+p 启动命令窗口，在命令窗口中可以找到打开setting的命令。
这个命令可以在专注模式下(标签栏隐藏)的情况下给恢复配置

# X11 forwardiing
X11 forwarding主要用途是打通ubuntu的界面展现于windows的界面展现，以及ubuntu剪切板与windows的剪切板
原理是ssh client能够将登录服务器的界面指令转发到windows中，并且由windows中安装的X server软件对指令进行解析之后，呈现界面

## ssh
ssh登录服务器时，需要增加 -X 参数，即可以启动用X11 端口转发
在被登录的服务中，需要设置DISPLAY变量值为: Xserverip:0.0  . 比如windows与ubuntu虚拟机之间局域网的地址是192.168.127.1
则DISPLAY需要设置为 192.168.127.1:0.0 

## XServer
windows中常用的开源XServer就是XMing。启动XMing时，需要在laucher中设置access control为禁用，则ubuntu通过ssh -X进行X11 forwarding
即可以工作. XMing laucher中的clipboard选项，则可以视情况而定。如果目前的终端已经支持OSC52协议(clipboard协议), 则这里可以关闭
目前windows terminal, alacritty都支持该协议，而xshell，securecrt则不支持

# 翻墙
安装SSR，使windows 客户端能够进行翻墙。同时配置ubuntu命令行环境下的 http_proxy, https_proxy环境变量(建议在rc文件中配置)，
指向SSR的代理端口(默认为1080), 并且SSR客户端中需要进行配置允许本局域网连接SSR代理。
这样子在ubuntu下的wget，git等命令，都能进行翻墙访问
操作系统对于http代理的支持，都是在应用层实现，要求不同的应用去遵循系统定义的代理接口, 比如http_proxy, https_proxy这些环境变量
这样子只要我们在一个统一的地方设置代理，则基本全部的命令都能够使用
但是有些命令，比如apt，或者一些python库似乎没有使用这些环境变量需要单独进行设置
ubuntu桌面上使用代理，则需要在桌面的设置/网络界面上进行设置

# remap caplock
由于我们的键位大量地依赖与ctrl键，而ctrl键实际上离键盘很远，所以一个较好的方案是将caps lock键remap成ctrl键，而不使用caps lock键的功能
这样子长久使用键盘的工作效率将变得很高
https://gist.github.com/krists/8898275
将上面的连接中的ctrl.reg保存成独立的问题，在windows上直接执行，再重启电脑即可

# windows窗体管理: aquasnap
重新绑定键盘键位，使用atl键来做窗体布局调整
atl + return    最大化，退出最大化
atl + m         最小化
alt + 上下左右  键调整窗体布局
alt + t         窗体固定在top，并且以半透明方式展现
则可以使用win键加 方向键，很方便地设置窗体停靠

# chrome配置
## git增强
### Sourcegraph
支持在git浏览代码中增加ide的go defination, go reference, 全局搜索代码，以及搜索文件的功能
极大增强浏览git中代码的便利性
需要登录才能释放全部的能力, 比octotree缺少一点的就是tab切换的功能
全局搜索代码的入口在代码仓库的顶部增加的 sourcegraph 图标, 点击进去的搜索栏，默认就是在代码行中搜索, 直接输入搜索关键字即可
比如:
repo:^github\.com/labstack/echo$ test

搜索文件的入口在代码仓库的顶部增加的 sourcegraph 图标, 点击进去的搜索栏，搜索文件需要使用 file: 
repo:^github\.com/labstack/echo$ file:basic

### octotree
支持在git浏览代码时增加树形浏览窗口, tab, 文件搜索等功能
需要登录才能释放全部的能力
双击树形列表即可按tab打开文件

### OctoLinker
支持在git浏览代码时, 能够通过import, include等关键字进行导航

### Octohint
支持相关变量，函数一起hint高亮.
单击代码即可生效

### gitzip
支持批量下载github中的文件.
点击需要下载代码的空白处，右下角会出现下载图标

### GitHub Hovercard
当页面中存在github的项目链接时，直接移动鼠标到链接上，则可以浏览到关键性的项目信息，比如start等
这个插件与awesome系列是绝配

### GitHub Code Folding
在github代码中支持foldering操作

## tab管理: onetab
对于开发人员而言，浏览器其实就是有点像命令行终端。当存在数量很多的网页的时候，需要对任务进行分门别类，这样子就能快速找到需要完成任务的窗口
onetab chrome插件可以用于对网页的标签页进行管理
在安装完成后，输入
chrome://extensions/shortcuts
并绑定ctrl + 1作为 onetab 显式的快捷键，并且设置为全局快捷键。
这样子当我们需要调出浏览器时，就可以直接按ctrl + 1 在tab one中进行tab页的搜索
或者在键入 ctrl+t 进行新的标签页搜索。若搜索内容是在剪切板中的话，此时再ctrl+v一下即可开始搜索

## 高效keymapping: vimium
https://vimium.github.io/
有用快捷键:
H L 在浏览历史中前进，后退
P 直接以系统剪贴板的内容打开标签页进行搜索
yt 复制当前tab页面地址，并且打开新的标签页
/ 在网页中启动vim的搜索模式
T 搜索打开的标签页并且进行跳转
o fuzzy打开bookmark，浏览历史等
f 在当前标签中打开一个链接
F 在新标签中打开链接
J K 在tab页中左移、右移
x 关闭当且标签页

## 翻译: 有道词典划词插件
鼠标双击单次，即可展现对应的翻译。节省大量查询不同内容的时间

## 自动分页
AutoPagerize 能够在使用google, github搜索结果时不需要反复点击next键

## 常用快捷键
ctrl + t 新建标签页。往往是搜索开始的入口

# 快速启动应用程序: wise hotkey
并且将secure crt，chrome等功能都以快捷键的方式进行绑定。
这样子就能够节省大量切换不同任务，应用的时间了

# 桌面搜索
安装wox
安装插件
Host      修改host文件
swicheroo 切换窗口
clipboard history 剪切板历史
need kv store插件
EveyThing需要启动运行
有道词典
ProcessKiller
Wox-Dash-Zeal
Wox.Plugin.Runner

常用功能:
atl + space    启动wox
win  关键字    搜索已经打开窗口
cb   关键字    搜索剪切板历史
g    关键字    搜素google
b    关键字    搜索浏览器标签
need Key         Get value of Key to clipboard
need Key Value   Save kv
need delete Key  Delete kv
hosts  关键字  编辑hosts文件
yd     关键字  有道中英文互译
kill   关键字  杀进程
z      关键字  搜索zeal
z py3: sys.v
z py3:sys.v
z py2,py3:sys.v
z rust,c:print
r ue  启动自定义命令ue. 自定义命令适用与绿色安装的软件，或者给名字特别长的命令生成alias

# 离线文档
安装Zeal

# 虚拟机
安装vmware16.00 版本虚拟机

# 屏幕截图
安装snipaste
配置
ctrl+\` 开始截屏
