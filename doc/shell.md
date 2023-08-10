# readline 快捷键
<C+h> 向前删除一个字符
<C+d> 向后删除一个字符
<C+w> 向前删除一个word
<Alt+d> 向后删除一个word
<C+u>删除一行
<C+a> 跳到行头
<C+e> 跳到行尾
<Alt+f> 前进一个单词
<Alt+b> 后退一个单词
<C+x > <C+e> 启动vim编辑器编辑当前命令行。用于长命令的编辑

# 正则表达式
## 正则表达式标准
Linux下正则表达式的标准至少分为basic poxis, posix extended, 还有perl 几个标准
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

# 高级文本过滤
## 寻找一个pattern，并且只匹配pattern中的一个子串
grep寻找一个pattern，并且只输出pattern中的其中一段match的字符:
https://unix.stackexchange.com/questions/13466/can-grep-output-only-specified-groupings-that-match
例子:
`grep -oP '(?<=cim_)\w+' file` 在file中寻找cim_开头的pattern，但是在输出中，只输出cim_后的一串word。
`(?<=pattern)` 是正则表达式中的虚拟匹配操作，会匹配字符，但是不会匹配到输出中去。更加具体的可以参考grep中正则表达式中的说明书
https://github.com/ziishaned/learn-regex/blob/master/translations/README-cn.md
在vim中，则有 \zs \ze 来提供匹配一个pattern中一个子串的能力

## 在一条命令中，进行正则表达式的与，或条件来过滤行中的内容
And条件过滤
```bash
grep -P '^(?=.*pattern1)(?=.*pattern2)'
awk '/pattern1/ && /pattern2/ {print $0}'```

详细可见
https://unix.stackexchange.com/questions/55359/how-to-run-grep-with-multiple-and-patterns

Or条件过滤
```bash
grep 'pattern1\|pattern2' ...```

## 获取 pattern1， pattern2之间的内容。
直接使用sed的range pattern。如果pattern2不存在，则仍然输出pattern1下面的内容
具体可以参考sed的标准说明
```bash 
sed -n '/pattern1/,/pattern2/p' file```

## sed
sed是一个流文件的编辑程序，所以其能力很大程度上是基于多个行的。
其中经常使用的 s// 命令, 使用posix extention进行匹配时，如要进行子括号引用，都是使用 \1 \2来进行表示 (表明这些引用自括号内容的符号，并不在posix的定义标准之内)
而 s// 命令只是其中一个替换命令而已
sed 命令的基本模式是 "pattern, pattern 命令"。这里的pattern可以是正则表达式, 或者是行号。
命令可以是 s a i c等常用命令

多个命令之间是可以进行嵌套的，含义是以上面一个命令处理完成的结果，再使用下一个命令来进行处理
比如:
```bash
# 对3行到第6行，匹配/This/成功后，再匹配/fish/，成功后执行d命令
sed '3,6 {/This/{/fish/d}}' pets.txt
```
sed命令的详细介绍可以见:
https://coolshell.cn/articles/9104.html

# 语法
## 空变量使用
出现在shell的条件判断表达式中的 变量引用，都需要带上""号来进行引用，否则有可能出现变量为空时，shell解析变量值不正确，或者语法出错等问题
比如:
```bash
if [ "$VAR1" = "string1" ]; then

fi
```
而避免
```bash
if [ $VAR1 = "string1" ]; then

fi
```
或者
```bash
if [ -e "$FILE" ]; then
  echo "alright it exists ... "
else
  echo "it doesn't exist ... "
fi
```
而避免
```bash
if [ -e $FILE ]; then
    echo "alright it exists ... "
else
    echo "it doesn't exist ... "
fi
```
引起这个问题的主要原因，是当不存在时，bash不会认为 $VAR 返回的是一个空字符串，而直接就是无。
```bash
if [ $VAR1 = "string1" ]; then
```
这种写法，当$VAR1 没有被定义的时候，就等价于
```bash
if [ = "string1" ]; then
```
所以自然会认为是语法错误
为了验证这个观点的办法，可以执行：
```bash
##var没有定义
cat             #没有参数，等待输入输出
cat $VAR        #没有参数，等待输入输出
cat "$VAR"      #有参数，为空，所以cat返回找不到文件
```
## split string to array
```bash
IN="bla@some.com;john@home.com"
arrIN=(${IN//;/ })
echo ${arrIN[1]}                  # Output: john@home.com
```
上面句子的含义是将IN中的;都替换成space，然后使用一个通过space分隔的字符串来构造数组
如果IN本身就是space分隔的话，上面的代码可以写成:
```bash
IN="bla@some.com john@home.com"
arrIN=($IN)
echo ${arrIN[1]}                  # Output: john@home.com
```
具体可以参考
https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash

# 日志分析
## less
1 通过行号关联分析日志
  可以开两个不同的tmux窗口，一个窗口用less显式已经过滤的内容，一个窗口显式还没有过滤的内容
两个窗口通过日志的行号来进行关联。这样子就可以做到类似ultraedit中过滤搜索分析日志的能力
显式行号: 
  在less命令行输入 -N, 即可toggle显式行号
定位到行号:
  在less命令行输入 xxxg, xxx为行号
只显式过滤内容:
  在less命令行输入 &pattern, 即可显式与pattern匹配的日志。

2 实时跟踪日志
  在less命令行输入 F开始跟踪，ctrl-C停止跟踪
