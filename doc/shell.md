1 正则表达式

不要在使用basic poxis的正则表达式。原因是这个表达式标准太弱，且符号很难进行记忆，与之前很多编程语言中的符号相差比较远。

至少要使用poxis extented标准。

在linux平台上，grep，sed中希望使用正则表达式时，请使用-E选项启用poxis extented 。

在vi上，则通过在正则的前面增加 \v 来启用poxis extented

基于到即使是这样子，在不同平台上，像\w \d这类表示字符集的标准还是不统一的。

几个不同的regext标准的关系，以及各个不同的平台支持的 字符分类 的汇总，请参考wiki上面的标准的说法

其中在linux下，grep，sed在-E下 与 poxis extention的 character classes table的 Perl/Tcl的定义是相一致的。

https://en.wikipedia.org/wiki/Regular_expression#Character_classes



在vim中非常有用，但是区别于其他平台的正则表达式的功能是 \zs \ze。 \zs \ze 来提供匹配一个pattern中一个子串的能力



 正则表达式的另外一个标准，就是Perl正则表达式PCRE。Perl的正则表达能力强于poxis extented，支持前后向断言等能力

具体可以参考:

https://en.wikipedia.org/wiki/Perl_Compatible_Regular_Expressions

 grep 的 -P 选项能够启用这项能力。而sed，vim的内置命令都不支持该项能力。vim要启用perl正则表达式，则需要使用perldo命令来启用。

但是像搜索，全局命令等场景都不能使用上



 2 寻找一个pattern，并且只匹配pattern中的一个子串

grep寻找一个pattern，并且只输出pattern中的其中一段match的字符:

https://unix.stackexchange.com/questions/13466/can-grep-output-only-specified-groupings-that-match

例子:

grep -oP '(?<=cim_)\w+' file    在file中寻找cim_开头的pattern，但是在输出中，只输出cim_后的一串word。

(?<=pattern) 是正则表达式中的虚拟匹配操作，会匹配字符，但是不会匹配到输出中去。更加具体的可以参考grep中正则表达式中的说明书

https://github.com/ziishaned/learn-regex/blob/master/translations/README-cn.md



在vim中，则有 \zs \ze 来提供匹配一个pattern中一个子串的能力



3 在一条命令中，进行正则表达式的与，或条件来过滤行中的内容

And条件

grep -P '^(?=.*pattern1)(?=.*pattern2)'
awk '/pattern1/ && /pattern2/ {print $0}'
详细可见
https://unix.stackexchange.com/questions/55359/how-to-run-grep-with-multiple-and-patterns



Or条件过滤字符串

grep 'pattern1\|pattern2' ...



4. 获取 pattern1， pattern2之间的内容。

直接使用sed的range pattern。如果pattern2不存在，则仍然输出pattern1下面的内容

具体可以参考sed的标准说明

sed -n '/pattern1/,/pattern2/p' file


5. vi and sed
vi的很多命令是来自于ed命令的。所以vi中的s命令，全局命令范围匹配的语法定义，都是与sed是相类似。
注意到vim中的i，a，c等命令的命名方式就是来源于ed编辑器的，所以sed中也存在这些命令。不过这些命令是作用在一整行上的
目前看起来vim作用与行的命令种类要比sed中的要多。更准确地说，vi比sed多了光标移动处理的能力，而sed的处理能力，基本上只能基于一整行来进行


其中经常使用的 s// 命令, 使用posix extention进行匹配是，如要进行子括号引用，都是使用 \1 \2来进行表示 (表明这些引用自括号内容的符号，并不在posix的定义标准之内)
sed是一个流文件的编辑程序，所以其能力很大程度上是基于多个行的。
而 s// 命令只是其中一个替换命令而已

sed (vi) 一个命令的基本模式是 "pattern, pattern 命令"。这里的pattern可以是正则表达式, 或者是行号。
命令可以是 s a i c等常用命令

多个命令之间是可以进行嵌套的，含义是以上面一个命令处理完成的结果，再使用下一个命令来进行处理
比如
# 对3行到第6行，匹配/This/成功后，再匹配/fish/，成功后执行d命令
$ sed '3,6 {/This/{/fish/d}}' pets.txt


sed命令的详细介绍可以见:
https://coolshell.cn/articles/9104.html



6 shell快捷键

<C+h> 删除一个字符

<C+w>删除一个word

<C+u>删除一行

<C+a> 跳到行头

<C+e> 跳到行尾

<Alt+f> 前进一个单词

<Alt+b> 后退一个单词

<C+x > <C+e> 启动vim编辑器编辑当前命令行。用于长命令的编辑



7 检查.so所依赖的动态库

使用objdump命令。依赖的动态库可以在 Dynamic Section 一部分中被找到

objdump -p exe

...
Dynamic Section:
...

8 通过关键字查找man
apropos keyword


9 csplit

可以通过正则模式来将文件拆分成几个独立的文件

有用的例子

https://www.golinuxcloud.com/csplit-split-command-examples-linux-unix/#1_csplit_based_on_regex_match



10 paste

paste命令是cut命令的反操作，可以将多个文件按列或者按行进行合并

https://www.howtoforge.com/linux-paste-command/



11 join

join命令与数据的join的含义是相同的，只是使用在文本记录上面。需要在文本有一个键将记录给串联起来

有用的例子

https://shapeshed.com/unix-join/



13 条件表达式

出现在shell的条件判断表达式中的 变量引用，都需要带上""号来进行引用，否则有可能出现变量为空时，shell解析变量值不正确，或者语法出错等问题

比如: 

if [  "$VAR1" = "string1"  ]; then

fi

而避免

if [  $VAR1 = "string1"  ]; then

fi

或者

if [ -e "$FILE" ]; then
    echo "alright it exists ... "
else
    echo "it doesn't exist ... "
fi

而避免

if [ -e $FILE ]; then
    echo "alright it exists ... "
else
    echo "it doesn't exist ... "
fi



引起这个问题的主要原因，是当不存在时，bash不会认为 $VAR 返回的是一个空字符串，而直接就是无。

if [  $VAR1 = "string1"  ]; then   这种写法，当$VAR1 没有被定义的时候，就等价于 if [ = "string1" ]; then，所以自然会认为是语法错误

验证这个观点的办法，是执行：

//var没有定义

cat                   //没有参数，等待输入输出

cat $VAR         //没有参数，等待输入输出

cat “$VAR”      //有参数，为空，所以cat返回找不到文件









