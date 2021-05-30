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

# xming
安装xming的主要用途是打通ubuntu的剪切板与windows的剪切板
此外我们可以在命令行中在windows中调起gui程序进行处理，其实是非常强大的功能
比如在命令行中输入 firefox, 则会弹出windows的命令窗口, 并且展现firefox的界面，并且能够进行鼠标交互

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
AutoPagerize 能够在使用google时不需要反复点击next键

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
F1 开始截屏
