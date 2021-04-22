# 编辑虚拟机ssh配置
编辑虚拟机与 开发虚拟机 增加 .ssh/config 文件，文件内容如下:
```bash
StrictHostKeyChecking=no
ServerAliveInterval 60
ForwardAgent yes
PubkeyAcceptedKeyTypes +ssh-dss

Host * !localhost !127.0.0.1 !172.*.*.* !192.168.*.*
User panxiangrong
Port 32200

Host * !*.sysop.duowan.com !localhost !127.0.0.1 !172.*.*.* !192.168.*.*
ProxyCommand ssh jump.sysop.duowan.com nc %h 32200 2>/dev/null
#ProxyCommand ssh extjump.sysop.duowan.com nc %h 32200 2>/dev/null
```
# ssh无密钥登录开发虚拟机
在目前的开发方式下，编辑虚拟机在本地编辑文件，然后将文件同步到 开发虚拟机上  
这需要 编辑虚拟机 与开发虚拟机配置无密钥 ssh 登录。配置方式如下:
https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication/
在开发虚拟上输入 
ssh-keygen
全部的提示都使用回车进行输入，即可生成公钥，密钥
公钥位置 ~/.ssh/id_rsa.pub
密钥位置 ~/.ssh/id_rsa
将 ~/.ssh/id_rsa.pub 拷贝到 开发虚拟机 ~/.ssh/authorized_keys 上，开发虚拟机的server即能够支持public key登录
即可通过 ssh 开发虚拟机ip 的方式登录到 开发虚拟机上
若有多台开发虚拟机，则都使用相同的密钥即可
注意到只要通过secure crt登录过到远端跳板机中，并且在secure crt中选择agent forwarding，以及分享密钥，此时我们也是可以在编辑虚拟开发机，以及开发虚拟机上面跳转到线上机器中的

在编辑虚拟机上能够登录开发虚拟机以及生产环境的主要原因 ，是当ssh连接一个服务器的时候，如果连接ssh的源终端配置了agent forwarding，会将机器上先尝试 agent fowarding 看能否进行登录。
如果不能成功，在尝试使用该用户账号在编辑虚拟机上所有能够找到的本地密钥。对于rsa key，ssh默认会搜索 ~/.ssh/id_rsa 尝试作为key
在我们的例子中，secure crt是我们的源终端，上面配置了agent forwarding，所以使用 secure crt登录编辑虚拟机后，编辑虚拟机再登录其他机器，会优先选择 agent fowarding。
所以在编辑虚拟机上登录 开发虚拟机时，会尝试agent forwarding，然后发现agent forwarding不能正确登录时，再尝试 默认的 ~/.ssh/id_rsa 发现能够登录
在编辑虚拟机上登录生产环境时，会尝试agent forwarding，然后发现agent forwarding能够正确登录，然后结束登录流程。

在编辑虚拟机跳转到在开发虚拟机后，在开发虚拟机上能够登录生产环境的主要原因如下：
首先我们通过secure crt登录编辑虚拟机，采用的已经是agent forwarding的方式。这意味着当任意登录的ssh请求想要尝试forward密钥请求到先前的链路时，都应该最终转发到最开始ssh终端，在这里的情况下是secure crt。
在编辑虚拟机登录开发虚拟时，根据agent forwarding的定义，编辑虚拟机的 ssh 终端会将登录开发机的请求转发到 secure crt，由secure crt来提供密钥信息
然后在开发虚拟机登录 生产环境时，根据agent forward的定义，开发虚拟机的 ssh 终端会将登录开发机的请求转发到 编辑虚拟机的ssh终端，ssh终端会再将请求转发到secure crt来提供密钥信息

上面这些点都是通过ssh终端的日志发现的。ssh的上述行为其实深刻地描述了agent forwarding的内涵。我们来分析下为何ssh的行为是这样子的：
* 为了能够满足首先跳转到若干个 intermedia_host，然后再通过 intermedia_host 跳转到真正目标的 target_host，由于 intermedia_host不能保存密钥信息，也不希望整条登录链路上的机器都要进行配置，
  所以采用了将密钥请求由原路中转到 远端的技术方案，并且agent forwarding是从远端进行配置的
* 这些中间的 intermedia_host 有自己的区别于 target_host 的认证方式。比如上面我们首先要登录一个中间的虚拟机。在整个登录链路上，拥有自己认证方式的intermedia_host有任意个。
  为了让agent forwarding能够工作，ssh终端 只能在登录一个另外一台 intermedia_host或者target_host时，先尝试agent forwarding的方式，如果不行，再采用ssh终端本地的password 或者密钥来进行登录。
  这样子才能让 agent forwarding这个能力能够完毕
* 为了让用户少输入信息达到 无密钥登录的功能，ssh终端在本地查找密钥时，会将所有可能的密钥都尝试一遍。

ssh本质上是能够在服务器之间进行可信的跳转的。一旦服务器之间建立了可信的连接，则我们可以在上面使用sftp，rsync，git等协议非常方便地进行通信，处理任务。
所以ssh真的是整个运维其实中处于基础地位的工具。

ssh 无密钥登录，agent forwarding等工作原理可以参考: 
https://dev.to/levivm/how-to-use-ssh-and-ssh-agent-forwarding-more-secure-ssh-2c32

# ssh本地端口转发
ssh本地端口转发的原理可参考：
http://www.ruanyifeng.com/blog/2011/12/ssh_port_forwarding.html
其本质就是可以建立起一个基于ssh信任连接的隧道

ssh本地端口转发的最主要用途，是可以让开发虚拟机模拟成一个真正的线上开发机器，去连接线上的db, redis, kafka等测试资源，极大地方便了整个开发调试工作。
这是因为我们自己去部署这些依赖的服务非常花费时间，而在开发调试阶段就将二进制的可执行程序上传到线上的测试开发环境则流程太长
当采用这种技术方案时，只要依赖于命名服务等需要暴露真实ip地址，或者服务器会动态返回ip地址(kafka就属于这种情况)，或者被访问的服务的ip地址是不固定的情况时，功能就不能正常地进行工作。
如果是简单的开发调试的话，我们可以在代码中直接访问可以进行配置的地址来绕过这个问题。
外网开发机访问本地开发虚拟机的问题，则可以通过ssh的远程端口转发的选项来加以解决。远程端口转发支持由开发虚拟机发起 ssh连接到外网开发机，但是转发的方向是支持从外网开发机转发到内网开发机，所以能够支持这项工作

# 后记
目前上面的讨论给出的方案已经过时。目前最为高效的开发方式，是编辑虚拟机直接登录外网测试开发机，然后将文件同步到测试开发机上。这样子就可以解决测试开发机与外部环境不通的问题。
但是下面的按理对于理解ssh agent forward的工作方式，以及本地端口转发，远程端口转发仍然非常有意义
