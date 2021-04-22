由于我们将 编辑虚拟机 与开发虚拟机分离，需要一种方便的方案，在编辑虚拟机上面编辑时，将信息同步到 开发虚拟机
这样子我们就可以使用一个tmux分屏登录到 开发虚拟机上面进行编译，调试，看起来与编辑虚拟机编辑窗口形成了一个集成开发环境
对于每个git上面的项目中在.workspance.vim中增加一个autocmd，当vim发生了buffer写的时候，将项目目录下的源代码都同步到远端去
注意到很多与源代码无关的东西，都需要进行过滤

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
