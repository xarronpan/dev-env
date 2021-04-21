安装secure crt 8.7版本



(1) 颜色配置

终端属性中，Terminal/Apperance 的color scheme 选择 solarized dark颜色


Terminal/Emulator 选择 xterm，选择 256 color，这样子从服务器发送给securecrt的信息流中的颜色，字号信息(这些信息的术语就是ANSI color)，才能被secure crt解释到

Terminal/Emulator 中勾选 use color scheme，则securt crt会将收到的ANSI color信息与color scheme进行一些映射之后，再会显式在终端上。



(2) 将鼠标滚动事件同步到远端

SessionOptions→Terminal 中，勾选Send Scroll Event to remote，这样子vim还有tmux才能响应鼠标滚动事件，并且进行屏幕的滚动



(3) 设置alter键

Terminal/Enulator/Emacs， 选择Use ALT as Meta key，选择Send Escape for meta key。

这样子在bash终端上，就可以直接使用alt键来在bash中进行移动

注意到这样子的配置，意味着alt键在vi上是不能直接进行使用的。这是因为vim认识的alt键是另外一个终端命令 (8bit)的模式。

在vi上面使用meta键，需要做一些特殊的remap。所以，在vi中，并不推荐使用meta键作为快捷键。目前我们通过在vim中进行一些配置，来将这种alt键的信号转成meta键。所以vim中也是支持alt键的功能的。



(4) secure crt支持在终端中直接打开浏览器来进行浏览

这样子终端上面也可以访问类似网页的东西

按键: ctl + 鼠标左键，点击url即可



