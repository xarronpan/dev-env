# 教程 
简易教程
https://www.liaoxuefeng.com/wiki/1016959663602400

cookbook
https://python3-cookbook.readthedocs.io/zh_CN/latest/preface.html

# 调试
python -m pdb err.py
pdb中的调试命令与gdb中的调试命令基本一致

# 语言特性
## 类型安全
python和javascript相类似是动态语言，错误都是在程序执行的时候才能被发现
但是与javascript不同，python是类型安全的。
比如说在javascript中，可以直接将字符串还是数字进行相加，甚至是相除而不会报错
在python中，字符串与数字进行相加需要对数据进行强制转型，因为在这种情况下python不能确认到底这是不是一个错误
否则python就会抛异常。这是python的 操作明确的设计原则一个具体体现。

## 整数
python3 里面的整数与其他语言的整数一个比较大的差异是不区分int，uint
都统一是有符号的，而且不需要担心溢出的问题，不需要程序员去定义int的位数
这样子其实的确是简化了程序员的工作，其代价是通过执行效率来进行换取
注意这点与python2是不同的。python2中是区分各种不同长度的int整数的
从这个角度上面来讲，python3要好于python2

## 字符串字符编码
python3 中默认的字符串都是unicode字符串。想要得到类似c/c++的bytes或者string,
需要通过encode/decode的方式将字符串转化为python中的bytes
这点设计与java的String是相同的, 也是相对合理的技术方案
注意这点与python2是不同的。python2中还有一个acsii字符串，实际上更加混乱
从这个角度上面来讲，python3要好于python2

## tuple
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
## list
python与其他编程语言另外一个大的差别是内置了很多与list直接相关的语言特性, 比如:
(1) 列表生成式
  https://www.liaoxuefeng.com/wiki/1016959663602400/1017317609699776
实际上, dict和set也都支持列表生成式
(2) 生成器
  https://www.liaoxuefeng.com/wiki/1016959663602400/1017318207388128
这些特性估计使得python在科学计算领域，复杂算法的表达上相对与其他语言会更加自然，有竞争力

## slice
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

## bytes && bytes array
bytes和bytes array是python中用于表示二进制数组的语言特性。
其关系与tuple与list之间的关系相类似， bytes是不可变的，bytes array是可变的，而这两个对象所支持的接口都是基本相同的
注意bytes和bytes array并没有被看成是一种list。这是因为python中的list可以放入不同类型的数据，但是bytes中的数据都指可能是8字节数据
所以将两者给混起来显然不是一个合理的方案

## 函数参数
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

## 匿名函数
python使用lambda 表达式来表示匿名函数. 需要匿名函数的主要原因是python是基于缩进, 没有符号界定函数的开始结束，
所以很难支持其他语言所能够支持的函数直接就地编写的写法。即使支持，使用起来也会很别扭。
所以作为补救，使用lambda关键字来创建匿名函数，并且匿名函数也只支持一行的表达式写法
所以对于匿名函数的支持，python实际上是要弱于其他的语言的。
而且这个lambda就是函数式编程中的lambda的含义
https://www.liaoxuefeng.com/wiki/1016959663602400/1017451447842528

## 装饰器
python的装饰器也是独有的语言feature, 提供了一种可编程的机制以声明式的方式，将行为绑定在类或者函数中的机制
类似于java里面注解的功能
https://www.liaoxuefeng.com/wiki/1016959663602400/1017451662295584

java中的注解以及python中的decorator都是相类似的语言特性。这些语言特性的主要作用是给类或者是函数增加行为(或者改变行为)。修饰器应该是对于这种语言特性较为准确的描述
首先其本质上的作用与函数相类似，目的是为了去除代码里面的冗余，将很多函数或者很多类中共同使用的功能给集中在一起。
典型的比如说函数需要打日志呀，或者是某个函数在运行单元测试的时候要给跑到之类的。如果没有这种机制，则没有办法将代码给编写在一起，增加程序的冗余
但是注意到，仅仅是 将很多函数或者很多类中共同使用的功能给集中在一起 还并不能直接推导出需要 decorator 这种语言特性的，因为像普通的函数调用也是能够达到这个目的的
所以decorator的另外一个特性是可读性。因为decorator出现的地方是与起作用代码的声明是在一起的，所以相对于在代码里面进行函数调用来修改类或者函数的行为，decorator这种方案是声明式的，可读性更加好

## 迭代器
在python中，Iterator还有Iterable是不同的概念
Iterable是指能够被 for in 循环所引用的对象。像list, dict之类的对象都是Iterable的
而Iterator则是指能够被next()函数所引用的的对象。比如生成器对象就是一个Iterator
两者进行分别对待的主要原因，是Iterator所指向的对象可以是无限的，而Iterable必须是有限的.
想要获取list, dict的Iterator，可以通过 iter() 函数获得
https://www.liaoxuefeng.com/wiki/1016959663602400/1017323698112640

## 私有变量, 函数
python中并没有语言级别去类似定义一个文件中的private, public访问权限的机制, 只有一个命名约定
约定以 _ 开头的函数或者变量都是在模块中私有的，__开始的变量或者函数则是系统内置定义的

对于class而言，则有相应的机制去防止外部接口访问内部数据。此时只需要class的内部变量被设置为__开头即可

## 反射
python在语言层面上定义了class，与java相类似，当希望绕开python class对象的类型限制，想通过更加高阶的方式访问对象的数据还有方法时，
需要采用反射的方式。python的反射函数为 getattr()、setattr(), hasattr(), 以及type(), isinstance等
比如说，我们希望能够动态访问class的某个属性或者方法, 而这个属性或者方法是在运行时进行指定的, 此时就需要使用到这里的特性。
比如需要高阶的对待不同类型的对象的时候。
python的class与javascript不同，对象本身不提供类似与字典的访问方式去动态访问对象的成员或者函数
python只所以这样子设计的原因，是动态访问的这种特性本身是相对边界的需求，并且容易在代码中引起错误。
因为当程序员真正希望使用这样子的高级特性时，应该使用一个有针对性的方案来解决这类问题。
而不应该像javascript这样子，只管提供机制能让程序员做到任何事情，而不管程序员是否容易引入错误
这点其实也是符合python语言设计上要求操作明确的设计哲学的
从这些观点可以看出，python的内核概念上与javascript是相类似的，都是动态数据组成的，但是python相对于javascript而言会更加的结构化，
是一个结构化的动态脚本语言, 比javascript限制更多，但是肯定没有那么容易出错

具体可以见:
https://www.liaoxuefeng.com/wiki/1016959663602400/1017499532944768

## 高级面向对象特性
python支持很多的高级面向对象特性，具体包括:
(1) 每个class所生成出来的对象，允许属性上存在差异
对象支持在通过类创建出来之后，再增加对应的属性。
如果希望被增加的属性是在某些范围内的，可以使用__slot__属性
```python
class A(object):
  def __init__(self):
    self.__name = 10


a = A()
a.my_attri = "test_attri"
```
(2) 支持多继承

(3) 支持动态修改类
python 通过引入metaclass来支持程序运行时修改类的行为。程序员可以在metaclass中动态地去往类中增加属性，方法等
一般而言，运行时动态地修改类本身的定义是比较极端的需求，在绝大多数情况下不需要进行使用。
但是，总会遇到需要通过metaclass修改类定义的。ORM就是一个典型的例子。
ORM全称“Object Relational Mapping”，即对象-关系映射，就是把关系数据库的一行映射为一个对象，也就是一个类对应一个表，这样，写代码更简单，不用直接操作SQL语句。
要编写一个ORM框架，所有的类都只能动态定义，因为此时用户所使用的类，在程序运行时用户给出了类与数据库字段的映射之前，结构是不可知的，
所以对应的类只能在运行的过程中生成。当然这个需求在python中其实也可以通过动态地构造类的实例对象来实现，但是动态生成的类能够沿用很多python类所支持的功能
比如说结构化的错误检查，较为复杂的继承关系等。如果纯粹动态地构造一个类的实例，则这些类本身提供的机制都需要该对象去进行模拟, 复杂度肯定更高
注意metaclass对象中的代码，是使用metaclass的类被定义时被调用的, 而不是这个类被函数代码执行的时候才被调用的
```python 
class ListMetaclass(type):
    def __new__(cls, name, bases, attrs):
        print("hello")
        return type.__new__(cls, name, bases, attrs)

class MyList(object, metaclass=ListMetaclass):
     pass
```
比如上面的代码，没有任何的函数调用，但是hello函数还是会被执行
在 `__new__`函数中去修改被创建的类的行为

metaclass有点像javascript中的prototype的语言特性，通过一个对象的prototype指向的对象本身来构造一个类，都能够实现动态修改类的能力
当然与反射的例子相类似，javascript支持这种功能的方式更加松散，更加容易出错，而python则提供了更加有针对性的语言机制来满足这一类需求
实际上两者的表达能力应该是相同的

(4) 通过参数指定需要创建的类对象
type()支持这种能力

(5) 类似于c++的类定制能力
比如说能够支持类在 for in表达式工作时，对应的class需要实现对应的__iter__()接口等等

(6) get set属性，enum类等
get set属性可以使用 @property 方法

具体可以参考
https://www.liaoxuefeng.com/wiki/1016959663602400/1017501628721248
