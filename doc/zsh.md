# 安装/配置
首次启动zsh的时候，直接使用2，默认采用zsh的default配置，则就有一个合理的zsh行为

# 常用功能
## 自动补全
### 接收auto suggest建议:
 ctrl + e  or ctrl + f (就是跳到行尾的快捷键，以及往前跳一个字符的快捷键) 接收整行的推荐
 atl + f (就是往前跳一个字符的快捷键) 接收一个单词的推荐

### 命令行参数补全
tab键
zsh不仅仅会补全文件名，所有的命令行参数都能够进行补全 (包括类似git add的输出也知道如何进行补全。这些都不是 oh my zsh的能力)

ctrl + o
唤起fzf 进行命令行参数补全。主要用于对命令行的参数进行补全时使用

### 目录fzz补全
 可以通过fzz补全缩减需要敲入的命令数量
 ls /g/d/p Tab  → ls /git/dev-env/projects

## 目录跳转
### 跳出子目录
不需要cd .. cd.. cd ..
只需要 ... 就可以跳出两层目录

### 调整当前目录
不需要cd命令，就可以直接调整当前目录
~    等价于  cd ~
doc   若doc不是命令，则 等价于 cd doc  

## 自动纠错
 当发现命令写错的时候，auto-highligth插件会给出红色的命令提示，此时键入tab，则zsh会自动给你进行纠错

## 快捷键 
上一个命令，下一个命令
ctrl+p, ctrl+n

上一个字符，下一个字符
ctrl+b, ctrl+f

删除到行头，删除到行尾
ctrl+u, ctrl+k

往前移动一个word，往后移动一个word
alt+f alt+b
注意alt间使用右手来按，这样子速度就快很多(emac的key binding本来就考虑到是这样子来设计，所以fb键都在左手)

往前删除一个word，往后删除一个word
ctrl+w atl+d
atl键同样使用右手来按

ctrl+s ctrl+q
ctrl+s ctrl+q 是bash下面的快捷键，因而在vim中不能进行重新绑定
在按入ctrl+s之后，终端会与终端的输出解绑。此时如果在vim中的话，看起来就是vim不能动了。这其实是终端不能进行输出引起的
再按入ctrl+q，则终端又会与输出建立绑定。知道这两个快捷键的原因在于有时候ctrl+a会误按到ctrl+s导致终端一动都不动。此时要知道恢复的办法才行

ctrl+x ctrl+e
比起在命令行中进入vim模式更为使用的功能，是使用ctrl+x，ctrl+e启动vim命令编辑器，编辑长命令。
此时vim中全部功能都能用上，自然能够提高编辑命令的效率。

## 解压命令
x  x可以解压任意文件

## 光标跳转: ace jump
在zsh命令行中，键入 ctrl+s，则会启动zce插件，模仿emac中的ace jump模式搜索文本。在zsh中输出参数的首选方式是该方式，明显要被采用vim的方式要快
这主要是由于进入vim模式需要额外的key输入，而且进入到了vim模式后，目前并不支持类似easy-motion的方式的移动，导致移动效率很低下。
进入vim模式快捷键: ctrl + j

# 语法
## 模式通配符
`*(/)` 所有的目录
`*(.)` 所有文件
`* (* )` 所有可执行文件
`* (@)` 所有符号链接
更加具体的能力，可以参考下面的链接
http://zsh.sourceforge.net/Intro/intro_2.html

## 递归查找文件作为命令参数
  zsh中集成了类似find + xargs的功能(在bash下需要这样子使用)，易用性更好。只需要敲入`**`，即表示递归查找
  `ls **/chat.conf   `ls 当前目录下所有(包括子目录下)的chat.conf文件

