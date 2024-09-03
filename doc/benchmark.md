#perf
参考:
perf整体使用思路:
https://cloud.tencent.com/developer/article/1115896

perf按时间采样生成火焰图:
https://senlinzhan.github.io/2018/03/18/perf/

总体而言，perf是比gperftools强大得多的profiling工具。首先不仅仅可以进行时间采用，对程序的堆栈进行快照，从而定位CPU执行时间的瓶颈,
perf也可以跟踪系统底层的os cache miss， l1, l2 cache miss，甚至分支预测失败等事件，对程序的堆栈快照，从而定位出性能瓶颈。
然后，对于程序的堆栈快照，不仅仅可以分析出程序用户态的堆栈，也可以分析出linux内核的堆栈。所以我们可以对性能消耗的时间有更加清楚的理解

1. 安装perf:
```bash
sudo apt-get install linux-tools-common linux-tools-generic linux-tools-`uname -r`
```
2. 按进程record perf.data, 用于生成这个进程对应的CPU火焰图
```bash
sudo perf record -p $pid  -g
```

3. 按线程record perf.data, 用于生成这个线程对应的CPU火焰图
```bash
sudo perf record -t $tid  -g
```

4. 将 perf.data 的内容 dump 到 out.perf, 用于转换成CPU火焰图
```bash
sudo perf script > out.perf
```

5. 通过out.perf, 生成火焰图
```bash
git clone --depth 1 https://github.com/brendangregg/FlameGraph.git
# 折叠调用栈
FlameGraph/stackcollapse-perf.pl out.perf > out.folded
# 生成火焰图
FlameGraph/flamegraph.pl out.folded > out.svg
```
#gperftools
参考:
https://github.com/gperftools/gperftools/wiki

在下面例子中, echo_server.exe是集成了gperftools libray的服务 

使用heap profiling来调查内存泄露问题:

可以通过程序内设置 check point 的方式来手动调用内存检查。服务端的内存分配模块使用了 tcmalloc，除了加速内存分配以外，还可
以利用 tcmalloc 自带的 Heap Profiler，来按需对内存进行检查。为了使用这项功能, 编译的时候, 链接选项要使用 
-ltcmalloc_and_profiler 选项

```bash
HEAPPROFILE=./echo_server HEAPPROFILESIGNAL=12 ./echo_server.exe
```

killall -12 echo_server.exe
生成第一个快照，名为 echo_server.0001.heap

killall -12 echo_server.exe

生成第二个快照 echo_server.0002.heap

用pprof 工具比对两个内存差别
```bash
./pprof --base=echo_server.0001.heap echo_server.exe echo_server.0002.heap  --dot >a.dot
```
生成的 dot 文件，可以用 graphviz 工具转换成图形
```bash
dot -Tpdf a.dot >a.pdf
```
从而对于内存使用一目了然。


使用cpu profiling来调查性能问题:
为了使用这项功能, 编译的时候, 链接选项要使用 -lprofiler 选项

```bash
CPUPROFILE=./echo_server CPUPROFILESIGNAL=12 ./echo_server.exe
```

启动服务
killall -12 echo_server.exe
生成CPU快照，名为 echo_server.0001.heap

```bash
./pprof echo_server.exe echo_server.0 --dot >a.dot
```
生成的 dot 文件，可以用 graphviz 工具转换成图形
```bash
dot -Tpdf a.dot >a.pdf
```
从而对CPU使用一目了然。

用 --help 参数可以得到 pprof 的详尽说明
特别注意的是, pprof执行解析的机器, 需要和echo_server.exe相同。否则输出的结果的堆栈会有问题。
还有pprof没有办法将内核CPU的使用情况给进行输出。进一步分析的时候, 可能需要perf工具

