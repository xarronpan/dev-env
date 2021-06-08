# 教程 
https://www.liaoxuefeng.com/wiki/1016959663602400

# 调试
python -m pdb err.py
pdb中的调试命令与gdb中的调试命令基本一致

# 整数
python 里面的整数与其他语言的整数一个比较大的差异是不区分int，uint
都统一是有符号的，而且不需要担心溢出的问题，不需要程序员去定义int的位数
这样子其实的确是简化了程序员的工作，其代价是通过执行效率来进行换取

# 字符串字符编码
python 中默认的字符串都是unicode字符串。想要得到类似c/c++的bytes或者string,
需要通过encode/decode的方式将字符串转化为python中的bytes
这点设计与java的String是相同的, 也是相对合理的技术方案

# tuple
python 中的tuple的地位就等价与python里面不可变的list，除了这点之外，tuple与list支持的功能都是等价的
python 中希望支持tuple的原因，是在很多情况下，tuple比list更加不容易出错
比如说 函数参数中的可变参数，就是通过 tuple进行表示的。另外例子去动态调用一个函数时，也是使用tuple来进行表示而不是list(具体见 函数参数一节)
这是因为调用参数时的列表被构造出来之后，应该是不可变的。
再有一个例子是函数的多返回值也是使用tuple来表示的
```python
# p 是tuple而不是list. 这是因为函数参数列表一旦调用就是不可变的，tuple更加符合起语义
def test_fun(param1, *p, param2, param3):
    print(param1)
    print(param2)
    print(param3 is None) #执行报错
    for i in p:
        print(i)

if __name__ == "__main__":
    test_fun("test_value", "v1", "v2", param2="abc", param3="def")
```

# slice
python 中支持类似golang的slice的能力, 通过[start:end]操作符获取一个list的子list。
与golang中的slice不同，通过slice表达式返回的list是区别与原来list的一个新list

``` python
    l1 = list(range(10))
    print(l1)   
    l2 = l1[:2]
    print(l2)
    l2[0] = 20
    print(l1)
    print(l2)

   #ouput
   #[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
   #[0, 1]
   #[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
   #[20, 1]
```

# 函数参数
python相对与其他编程语言的一个主要特点是丰富的参数表达方式，包括:
  默认参数
  可变参数
  关键字参数
  命名关键字参数
等特性
具体可以参考
https://www.liaoxuefeng.com/wiki/1016959663602400/1017261630425888
下面增加一些补充

(1) 命名关键字参数的feature等于是给参数起名字，函数被调用时，参数必须的。这点和关键字参数特性很不一样
```python
def test_fun(param1, *, param2, param3):
    print(param1)
    print(param2)
    print(param3 is None) #执行报错, 因为调用时param3参数没有指定

if __name__ == "__main__":
    test_fun("test_value", param2="abc")
```
(2) 在Python中定义函数，可以用必选参数、默认参数、可变参数、关键字参数和命名关键字参数，这5种参数都可以组合使用。
    但是请注意，参数定义的顺序必须是：必选参数、默认参数、可变参数、命名关键字参数和关键字参数。
比如定义一个函数，包含上述若干种参数：

```python
def f1(a, b, c=0, *args, **kw):
    print('a =', a, 'b =', b, 'c =', c, 'args =', args, 'kw =', kw)

def f2(a, b, c=0, *, d, **kw):
    print('a =', a, 'b =', b, 'c =', c, 'd =', d, 'kw =', kw)
```
在函数调用的时候，Python解释器自动按照参数位置和参数名把对应的参数传进去

```python
>>> f1(1, 2)
a = 1 b = 2 c = 0 args = () kw = {}
>>> f1(1, 2, c=3)
a = 1 b = 2 c = 3 args = () kw = {}
>>> f1(1, 2, 3, 'a', 'b')
a = 1 b = 2 c = 3 args = ('a', 'b') kw = {}
>>> f1(1, 2, 3, 'a', 'b', x=99)
a = 1 b = 2 c = 3 args = ('a', 'b') kw = {'x': 99}
>>> f2(1, 2, d=99, ext=None)
a = 1 b = 2 c = 0 d = 99 kw = {'ext': None}
```
通过一个tuple和dict，你也可以调用上述函数：
```python
>>> args = (1, 2, 3, 4)
>>> kw = {'d': 99, 'x': '#'}
>>> f1(*args, **kw)
a = 1 b = 2 c = 3 args = (4,) kw = {'d': 99, 'x': '#'}
>>> args = (1, 2, 3)
>>> kw = {'d': 88, 'x': '#'}
>>> f2(*args, **kw)
a = 1 b = 2 c = 3 d = 88 kw = {'x': '#'}
```
python支持这种方式的调用的主要原因，是在有一些很极端的场景之下，我们不希望去hardcode调用函数的参数，而是通过代码的方式来构造对应的代码
这样子就可以将一些冗余的代码给抽象出来。这种需求通常出现在抽象程度很高的框架代码中
