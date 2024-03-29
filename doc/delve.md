# 概述
delve是golang的调试器。其使用方式比gdb相对而言要简单，需要进行配置的东西也相对较少

# 注意事项
## 关闭优化选项
注意需要使用delve来进行调试的时候，若golang的优化开关没有被关闭，则有可能在堆栈中的变量信息，在调试器中不能顺利地被
print出来。
但是在这种情况下， 程序的执行位置还是能够被指定的。
若要关闭golang的优化选项，则在运行go build的时候，增加-gcflags="all=-N -l"参数
比如下面的命令：
```bash
go build -gcflags="all=-N -l" -o output/bin/globalsync_dispatch_d main/main.go
```
# 安装
使用delve来调试程序的其中一个问题，是这个调试器不一定在每台机器上面都有，而且没有像gdb那么强大，能够将线程的执行给锁住。
在线上机器调试运行的时候，需要在被调试机器上面安装golang，以及这个delve
在线上机器进行调试时，只需要安装golang编译好的代码包，然后再安装delve即可。由于基本上不需要进行编译，所以这个调试器的部
署时间还是很短的。
golang install
https://golang.org/doc/install
delve install
https://github.com/go-delve/delve/blob/master/Documentation/installation/README.md

# 常用命令:
启动调试进程
例子
dlv debug git.agoralab.co/shen/mde_cdn_bridge -- -config-file test.toml
这个命令会启动适当的参数编译应用程序，从而保证被编译的代码都能在devle中正确地调试
例子中的  git.agoralab.co/shen/mde_cdn_bridge 目录下需要有main包，以及main函数定义
`--`后面表示的是被调试程序的参数.

命令行参数:
https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv.md

调试命令:
https://github.com/go-delve/delve/tree/master/Documentation/cli#trace

help命令就能给出全部的调试命令集合，使用起来比较简单
