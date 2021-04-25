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

## 常用快捷键
ctrl + t 新建标签页。往往是搜索开始的入口

# 快速启动应用程序: wise hotkey
并且将secure crt，chrome等功能都以快捷键的方式进行绑定。
这样子就能够节省大量切换不同任务，应用的时间了

# 剪切板管理: copyq
用于复杂运维操作时，不需要反复到终端上获取需要信息
在选定了剪切板内容之后，按enter，即会将内容copy到剪切板中。
copyq在网页，或者在终端上都能够进行使用。
对于一些临时性质需要进行管理，并可能需要进行输入的内容是比较实用的
配置:
配置启用使用vim快捷键
ctrl+y  触发copyq
ctrl+m  给剪切板内容增加标签
ctrl+i  标记剪切板内容为重要
ctrl+f  固定剪切板内容
# 虚拟机
安装vmware16.00 版本虚拟机
