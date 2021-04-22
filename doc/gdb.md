#调试原理
gdb调试器的主要工作原理，是使用符号信息，外加依赖于操作系统提供的api来实现断点，step等功能的。也就是说linux的其他系统命令，也提供了对于运行中的程序进行调试的能力，而不仅仅是gdb的能力
这也不奇怪在Linux下有一系列动态调试进程，获取进程信息的的工具链了。
断点则是操作系统内核依赖于CPU的软中断机制来进行实现的。CPU中有专门为调试器使用的软中断指令int 3。
其实也可以想象，当我们需要去调试进程时，如果没有CPU级别的指令支持，则等于需在在线性的程序地址空间中去插入代码，才能做到改变进程执行流程的能力，显然是不现实的。
这是因为此时程序第地址空间就需要进行大幅度的平移
具体的工作原理如下: 
"INT 3指令产生一个特殊的单字节操作码（CC），这是用来调用调试异常处理例程的。
（这个单字节形式非常有价值，因为这样可以通过一个断点来替换掉任何指令的第一个字节，包括其它的单字节指令也是一样，而不会覆盖到其它的操作码）。"

详细可见：
http://abcdxyzk.github.io/blog/2013/11/29/debug-debuger-1/
按照这种方式分析下来，则发现其实在调试程序的时候，动态去注入一些代码，比如加入打印日志，其实并不会对进程的执行性能造成多大的影响。这是因为进程的执行指令并没有收到干扰

# 配置
## 提高易用性: gdb-dashboard
https://github.com/cyrus-and/gdb-dashboard
在被调试的目标机器上，很容易就能安装好展现环境。使用git clone将.gdbinit给clone下来即可
版面中的内容是可以进行任意配置的。在gdb中输入 help dashboard
可以对版面是否打开关闭进行配置，并且进行持久化。在gdb中输入 help dashboard -configuration 查看详细的配置方式
如果需要更好的代码语法高亮的话，需要安装 pygments。pygments依赖与python 3，所以需要使用 pip3 install Pygments 的方式来进行安装
目前这个dashboard只对在gdb中run的程序能够生效
配置高亮语法:
dashboard -style syntax_highlighting 'solarized-dark'
使配置生效:
dashboard -configuration ~/.gdbinit.d/init

## 配置寻找源代码的目录
一般而言，gdb在调试的时候，需要源代码的原因，就是需要在控制台中输出源代码，这样子我们才能知道当前代码执行到了什么位置，而不仅仅是看行号
即使没有源代码信息，gdb其实也是可以对变量的值进行print的。这是因为符号信息已经是完整的了。这其实意味着分析coredump文件，其实不需要源代码的信息，只需要我们能够找到对应版本的源代码来进行分析即可。
gdb去load源代码，依赖于 生成在可执行文件中的 文件编译位置， 以及编译目录位置信息，在加上gdb中设置的 源代码搜索位置。
假设可执行文件为test，源代码为test.cc，则
获取文件编译位置：
```bash
objdump -g test|grep DW_AT_name|grep test.cc ```
获取编译目录位置：
```bash
objdump -g test|grep DW_AT_comp_dir```
gdb首先会搜索  文件编译位置。然后组合gdb的一些设置进一步搜索源代码
有时候当我们在线上调试程序的时候，文件编译位置可能权限较高。我们可以将源代码拷贝到一个有权限的位置，并进行下面的配置，让gdb能够顺利进行调试，
假设源代码的文件编译位置为 /project/....  可以将代码目录 project 到 DEST_DIR/project
然后启动gdb进行调试。在加载了待调试文件后，输入:
```bash
directory DEST_DIR
```
这之后gdb就知道从 DEST_DIR/目录下，进一步搜索 源代码的文件编译位置 /project/...
一般而言一个项目中所有文件的文件编译位置模式都是相类似的，所以只要在进行调试的时候进行一次配置，应该能对一个项目中的所有源代码都能生效
更加详细的步骤还有选项，请参考:
https://alex.dzyoba.com/blog/gdb-source-path/
https://sourceware.org/gdb/current/onlinedocs/gdb/Source-Path.html#Source-Path
注意上面的设置方式，对于attach到进程，以及对动态库 进行调试也是能够进行工作的。

# 打印信息
## 打印stl容器中的内容
目前线上gdb的版本7.11，已经支持对stl的内容直接进行打印，而且打印的内容已经非常地漂亮。
注意到即使对于复杂的结构，目前也能够很好地进行展现。这些功能是通过gdb的python扩展来进行实现的。Python扩展中包括了对stl的扩展展现能力
https://wizardforcel.gitbooks.io/100-gdb-tips/content/print-STL-container.html
如果这种方式不能工作，gdb是支持在单步调试时，直接去调用函数的。
我们可以封装一个展现c++容器内容的函数，然后在gdb的命令行中进行调用。
call和print命令都能做到这项事情
https://wizardforcel.gitbooks.io/100-gdb-tips/content/call-func.html

## 打印长信息
这个需求最多出现在需要print proto中的信息的时候。
输入下面的命令，则长内容的中东西会全部被答应出来
set print elements 0

## 动态加入log
gdb支持通过 dprintf 来支持在代码中动态加入日志的能力。这个能力能够在调试程序时很方便地进行使用，能够随时往代码中增加日志来观察输出的结果
在待调试程序中需要有一个能够接受 format 字符的函数, 比如：
```cpp
void __attribute__((used)) Log(const char* fmt, ...) {
  char buf[512];
  int nbytes = 0;
  va_list ap;
  nbytes = snprintf(buf, sizeof(buf), "%s %s: ",
                    "test_file",
                    "test_fun");
  if (nbytes + 1 >= sizeof(buf)) {
    return;
  }
  va_start(ap, fmt);
  vsnprintf(buf + nbytes, sizeof(buf) - nbytes, fmt, ap);
  va_end(ap);
  std::string buf_str(buf);
  std::cout << buf_str <<std::endl;
} ```

这就要求我们的日志库代码要提供一个这种形式的接口。由于代码使用的都是同一个函数，所以提供一个统一的调用入口并没有特别大的问题。此外注意这个函数应该使用 __attribute__((used)) 属性，避免因为函数没有被调用，而直接没有被链接到程序里面
然后在gdb中输入下面的命令:
```bash
set dprintf-style call
set dprintf-function Log                 # 设置待调用的函数是Log
set overload-resolution off              # gdb调用变参函数时，如果启用overload-resolution的话，会报找不到函数定义的问题。所以在这里要将这个开关给关掉
dprintf thread.cc:32, "a=%d", a          # 在thread.cc 32行，使用格式字符串 "a=%d" 来打印上下文中 a 的值。
```
## 分析复杂变量状态
### 获取符号类型定义
gdb是支持运算符重载的表达式的。对于简单的模板对象中定义的operator重载，我已经测试过能够在gdb中正常地进行引用。
但是到对于一些较为复杂的c++运算符，目前是不支持在gdb中直接被调用来检查结果的。比如std::map<string,string>, 则在 gdb中输入 p map["test_key"] 是不能正确工作的。这是因为std的对象类型过于复杂，导致了gdb找不到函数的重载版本。
一般而言，对于stl，我们已经有能力去检查stl的内容了。但是我们真实调试程序时，还是有大量的变量状态代表了复杂的数据结构。尤其是当进程发生了崩溃的时候去检查变量状态。有时这些变量的状态实际上非常复杂。
我们对这类结构进行状态分析检查的方法有两个
 * 获得这类复杂结构的符号定义，并且使用内存结构去迭代访问
 * 获得这类复杂结构的符号定义，并且使用符号上面的函数去对确定内存的状态
两种方案，都省不了去获取被调试对象的类型符号定义。
```bash
whatis var              # 这个命令用于获取var对应的类型。类型信息不会包括成员，函数定义
ptype type              # 这个命令用于获取用whatis var中获取到的type信息的详细定义，包括函数定义，以及成员定义
ptype var               # 作用同上，不需要类型信息
ptype /r var            # 对于模板对象，展现详细的模板函数定义，成员定义
info functions regex    # 这个命令用于获取符合regex特征的函数的符号 比如说 info function operator\[\]，regex表达式不能使用字符串引住
info types regex        # 这个命令用于获取符合regex特征的类型定义符号 比如说 info function map，regex表达式不能使用字符串引住
```
一般而言，即使对于模板所定义的代码，gdb也是有能力去获取正确的函数定义来进行分析调用的 (这点已经采用测试验证过了)
但是对于stl这类实在过于复杂的类型定义，gdb除了依赖与内置的python来显式对象的状态，实在是没有其他更加好的办法。
此外注意到当 在分析 corefile 文件时，由于已经没有进程被拉起来，所以全部希望在 gdb 中调用函数来获取堆栈对象状态的方式都不能工作了。
gdb无法通过corefile来恢复进程镜像的原因是进程的状态包括了进程内核态的堆栈的状态，很难进行恢复。这也就是意味着在开发的时候，假设希望去获取进程的崩溃堆栈，最为合理的方式仍然是通过gdb直接拉起进程来做调试
这样子进程的全部信息都是有的。当发生崩溃时，你能够获取到全部能访问的调试能力。但是用gdb来进行corefile调试的时候，就基本上做不到这些事情。只能通过内存结构的地址去反向引用内存中的东西
如果这个时候我们真的很希望去分析出一个复杂结构的值，只能通过获取类的数据结构状态来进行分析。对于过于复杂的第三方数据结构，比如proto buf中的map定义，似乎也很难在coredump中将相关的状态给获取出来
一般在对进程进行调试时，可以通过proto_buf的 DebugString() 能力来对protobuf进行调试
具体的手册可见:
https://sourceware.org/gdb/current/onlinedocs/gdb/Symbols.html

### 强制对指针地址值进行转换，输出结构内容
对于类似std::shared_ptr这类对象，gdb的p命令一般能够给出std::shared_ptr所包含的地址值。此时我们可以将该地址值进行强制类型转换，这样子就能得到一个结构化的输出:
比如 p (*(cim::store::MsgWorker* (ptr_value)))
这种方式也可以在分析内存的时候，应用到任意复杂结构的数据分析中

# 断点/条件断点/ 观察断点
可以在被调试的文件名前面加入路径前缀，用于区分不同的文件
 ```bash
b src/server1/logger.cc:40  #假设有若干个logger.cc，则只调试src/server1/logger.cc。注意源代码位置的设置，见本文后面的说明
 ```
可以在gdb中输入类似的命令，只有当条件满足的时候，断点才能被触发。断点的条件可以是任意源代码中的条件表达式。
```bash
b stl.cc:33 if vec.size()==20
```
gdb同样支持当某个全局变量值发生改变时，进入断点。
命令为 watch expression
https://wizardforcel.gitbooks.io/100-gdb-tips/content/set-watchpoint.html
注意到watch point并不支持额外的复杂条件，只支持变量值改变时进入断点

暂时取消断点:
```bash
disable break_point_id  #使得在break_point_id上不中断```
https://sourceware.org/gdb/current/onlinedocs/gdb/Disabling.html#Disabling

# 调试多线程
## 打印线程信息，切换线程进行调试
```bash
i threads              #打印全部的线程信息
thread gdb_threadid    #切换到gdb_threadid的线程中进行调试。当切换到另外一个线程中后，可以直接在另外一个线程中进行step/next来进行调试。
                       # 在没有将其他线程停止掉的情况下，可以在被切换到的线程进行step/next调试，直到另外个线程中的断点被触发。
                       # 此时gdb又会切换到触发断点的线程，并且中断所有线程的执行。当我们在触发断点的线程输入step/next等命令后，其他的线程又会继续往下执行```
详细见:
https://wizardforcel.gitbooks.io/100-gdb-tips/content/print-threads.html

## 一个时间点只允许一个线程执行
```bash
set scheduler-locking on```

详细见:
https://wizardforcel.gitbooks.io/100-gdb-tips/content/set-scheduler-locking-on.html
这种方式特别适合于在线程级模拟多线程的调度行为是否符合预期。当多线程间的交互非常复杂时，适合于使用这种方式进行调试
注意到当一个线程被断点stop掉了之后(一个线程进入了断点)，因为需要同时发信号给其他线程，让他们也进入stop状态，从而能够进行调试，所以当其他线程本身是在进行系统调用时，系统调用会以收到信号的方式，提前退出。
所以为了让被调试线程保持正确的行为被调试，每个系统调用都应该检查是否是由于信号的中断导致退出。如果是的话，需要再重试进入函数进行处理。
详细信息可以参考下面的文档:
https://sourceware.org/gdb/current/onlinedocs/gdb/Interrupted-System-Calls.html#Interrupted-System-Calls







# 测试系统的异常分支
在进行调试的时候，有很多情况下有些分支不能正常跑到，但是测试上面又需要进行代码分支的覆盖。
之前的办法是直接采用修改代码的方式来进行测试。这种方法的缺点在于慢，并且影响到了源代码，所以并不是很正规。
在使用gdb之后，可以在gdb中直接修改变量的值来模拟程序的异常行为
https://wizardforcel.gitbooks.io/100-gdb-tips/content/change-string.html
例子:
```bash
set var a = 10          #设置变量a的值为10
```
执行return语句，能够在当前调试的函数中，提前返回到被调用函数中
https://sourceware.org/gdb/current/onlinedocs/gdb/Returning.html#Returning

# 调试c++函数
要对c++的组成部分进行引用是，采用c++的语法引用即可。目前测试过的gdb的行为都是符合预期的。下面的结论对于namespace也是成立的
## 设置c++函数断点
要对c++函数进行设置断点时，采用c++的语法引用对应函数。这种方式是最符合预期的。
```bash
b A::thread1_func
b hiido::Logger::Init  #hiido为namespace
```
## 查看类静态变量
对类的静态变量进行查看时，在名字前面增加c++的语法进行引用。
如果是在类的成员范围内，也可以直接与c++的语法类似去访问 a。否则在类的成员范围以外，需要额外进行引用
```bash
  p A::a```
## 访问静态函数
与上面的规则类似
```bash
call B::Log("a=%d", a)
```
## 访问类成员变量
在类中，可以直接访问对应的值:
```bash
p  test1_```
在类的外面，需要对象来进行引用:
```bash
p c.test1_```
注意在使用gdb来进行调试时，符号是不区分private与public的。

# 调试正在运行的进程
在shell中输入
```bash
gdb target_file           #target_file是待调试进程的二进制可执行文件，里面包括了二进制信息
```
然后在gdb中输入
```bash
attach target_process_id  #target_process_id是待调试进程id
```
一般而言，对正在运行的进程进行调试需要较高的执行权限。
当程序被attach之后，当前程序还是继续在进行执行的了
在使用gdb拉起调试进程后，若没有进入断点，则在gdb中输入ctrl-c，则能够使当前被调试进程在一个执行位置中挂起，等待调试

# 调试动态库
gdb中调试动态库，与调试普通进程的流程并没有区别。
当使用gdb 启动了被调试进程后，哪怕.so还没有被加载进程序，我们也能够在程序执行之前，就指定好需要中断的位置。
这样子gdb run的时候，就会进入需要进行调试的动态库中。
注意到即使被调试进程本身没有符号，gdb仍然是可以进入动态库进行调试的。
通过dl_open被加载的动态库，已经测试过，也是能够在.so中设置断点，然后在gdb run的时候，跑到断点里面去的。
需要注意的是由于在进行调试的时候，由于.so还没有被加载，所以当设置.so中的断点，比如 b logger.cc:40 的时候，gdb会提示:
`
>>> b logger.cc:40
No symbol table is loaded. Use the "file" command.
Make breakpoint pending on future shared library load? (y or [n])`
这时只要选择y，当函数执行到断点中，就能被调试进去。
其实.so 自动加载的地址，与gdb使用dlopen打开动态库的机制本质上并没有区别，所以gdb中能够进行调试其实也不出意外

# 调试coredump
## coredump生成
Linux系统要生成coredump其实非常简单。首先检查当前终端的ulimit
```bash
ulimit -c```
如果为0，则表示coredump不能生成
需要生成，可以执行
```bash
ulimit -c unlimited```
则当前终端中就能允许生成coredump
coredump的生成位置是属于内核的配置行为
配置位置为: /proc/sys/kernel/core_pattern
通过
```bash
cat /proc/sys/kernel/core_pattern ```
就能知道coredump生成的位置
https://www.cnblogs.com/Anker/p/6079580.html

## coredump分析
```bash
gdb target coredump_file```
在输入该命令后，就会启用gdb进行调试。此时gdb dashboard中的东西已经不能打印出来了，需要手动输入gdb的命令来进行分析
此时可以通过gdb的表达式来分析当前进程中所有能够访问的变量的值。
gdb启用coredump去调试进程的时候，就与普通的gdb的环境下去调试进程的行为手段没有差别。
bt可以显示当前线程的运行堆栈。
coredump有时候困难的是准确判断崩溃的位置。一般而言，coredump中会直接给出崩溃的函数已经行号。
如果源代码的位置很明显能够确定是引起崩溃的话，就不需要下面的分析。这点可以通过对符号反引用进行分析得出结论，比如引用的指针值实际上是否能够进行访问，具体的值等。
这里有个重要的分析方法，通过 
```bash
up n
down n
info frame    #打印当前栈帧的信息。注意到在栈帧发生移动时，bt命令返回的堆栈结构还是不会发生变化的。```

可以在堆栈中进行切换，从而可以结合gdb的表达式，分析不同调用堆栈中的值的情况。这些值在顶层的堆栈中是无法使用gdb的expression来进行引用的。
注意在往上往下切换了堆栈之后，i register 以及 x/20i $pc - 40 等表达式 (见后面的分析) 也会切换到相应的堆栈，方便对崩溃的具体情况进行进一步的分析。
理论上有了任意堆栈上面的信息，加上内存中的映像信息，则我们也会有相当大的能力能够对足够多的信息线索进行回溯，从而看能否找到引起崩溃的原因。
一般而言不太应该首先假定整个堆栈的结构已经受到了破坏。
堆栈是否受到破坏一般可以简单地通过堆栈上面的调用地址是否与代码堆栈预期相同来进行判断。
如果整个堆栈都受到了破坏的话，则通过gdb表达式计算出来的变量值本身也是异常的了。
在遇到堆栈被破坏的情况下，首先可以通过bt的分析，对正确堆栈的位置进行猜测，然后通过up n, down n的方式回到堆栈仍然正常的上下文中，进一步进行数据分析。
此时进一步分析崩溃堆栈的栈顶已经是每个特别大的意义。因为此时引发bug的位置并不在那个地方了。
然后将汇编代码给列举出来，然后分析线程堆栈的pc指针位置。这是因为pc的指针位置肯定是准确的。这时候的分析已经是相对比较困难的了。

有用指令:
```bash
info registers    #获取全部寄存器的值。其中在x86体系架构下，rip就是指令寄存器。
x/20i $pc         #显示 $pc指针后20行的汇编代码
x/20i $pc - 40    #显示 $pc 指针前40个地址的汇编代码地址，显式20条。用于展现崩溃出现附近的汇编代码
```
输出的汇编代码如下:
`
0x400fea <test::A::thread1_func(void*)>: push %rbp
0x400feb <test::A::thread1_func(void*)+1>: mov %rsp,%rbp
0x400fee <test::A::thread1_func(void*)+4>: sub $0x20,%rsp
0x400ff2 <test::A::thread1_func(void*)+8>: mov %rdi,-0x18(%rbp)
0x400ff6 <test::A::thread1_func(void*)+12>: movl $0xc,-0x4(%rbp)
0x400ffd <test::A::thread1_func(void*)+19>: mov 0x2011d1(%rip),%eax # 0x6021d4 <_ZN4test1A1aE>
0x401003 <test::A::thread1_func(void*)+25>: add $0x1,%eax
0x401006 <test::A::thread1_func(void*)+28>: mov %eax,0x2011c8(%rip) # 0x6021d4 <_ZN4 
`
最左边表示的是指令的地址，然后`<>`内的是函数在源代码中的名称。然后+1, +4等符号表示的是这条指令相对于函数开始地址的相对地址。
汇编函数的真正含义，可以在真正进行崩溃的分析的时候，再来进一步进行详细分析

可以通过disamble 命令，混合源代码与机器码，方便进行进一步的分析：
```bash
disas /m 0x400fea,0x0x401006    # 在指令地址 0x400fea,0x0x401006 间混合打印机器码与源代码
disas /m A::test                # 混合打印 类A 的函数 test 的所有机器码与源代码 
```
## gcore
gcore命令可以将运行中的进程的内存镜像给dump下来，然后启动gdb来进行分析内存的消耗
命令:
```bash
gcore -o output_filename pid
```

# 远程调试
远程调试目前在我的工作流中暂时使用不上。这里只记录主要的原理：
在target机器上面运行gdb server，然后在调试机器上面启动gdb，并且通过协议连接到gdb server上。
这样子，只要在调试机器，或者gdb server上面有被调试程序的符号信息，以及能够找到被调试程序的源代码，就能够与正常使用gdb来进行调试的方式，对程序进行调试。
