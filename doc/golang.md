# packages官网
https://pkg.go.dev/

# feature分析
## go mod
golang1.11 之后引入了go mod，用于管理golang包的版本。
golang包的管理方案除了下面一点较为特殊之外，与其他的包依赖管理系统基本上都是相类似的。
包括能够自动下载包，指定下载包的版本。下面重点描述go mod的特殊之处

### 基于源代码的发布
golang模块的发布都是基于源代码的方式发布的。所以我们会发现在golang里面没有编译静态库，动态库的命令
使用go get 命令之后，golang会在客户端本地编译基于源代码方式发布的golang模块，然后再在go build的时候与这些编译好的模块进行链接
这个方案其实与c/c++中hunter的方式是相类似的
由于模块是基于源代码的方式发布的，所以获取代码最为简单的方式是依赖与git。而对代码版本进行区分的最简单的方式就是使用git的tag来区分版本
go mod的包发布可以见下面的连接:
https://golang.org/doc/modules/developing

### 版本约定
大版本号不一定能够保证api兼容，小版本一定保证api兼容，patch版本号保证api版本不发生变化
这个版本方案，就是的golang在出现菱形包依赖的时候，能够解决包版本兼容性的问题。具体可以看到下面的分析
https://golang.org/doc/modules/version-numbers

### 菱形包依赖解决方案
当正在编辑的模块A 依赖与 B、C模块，而B、C模块都依赖与D版本的模块，而B、C模块假设依赖的包D的版本号
 * 大版本号是相同的，则此时使用小版本号更大的版本即可保证兼容
 * 大版本号是不同的，则此时golang约定两个包必须在不同的包路径下，因而可以认为是两个独立的包，所以该问题就能够被进行解决。
https://blog.golang.org/v2-go-modules

## go slice
golang的slice与其他语言中的数组在设计上面差别比较大。
主要的结论，是slice是静态数组或者是动态数据的引用或者指针，其本身所指向的数组在一旦创建之后，是不会发生变化的。这点和c++中的vector其实是很像的。
slice的[start:end]获取新slice的操作符，每次都会以slice所指向的数组为参考重新生成另外一个切片。
而[index]运算符，则是以当前slice的start，end的位置来访问数组的数据。
这里就存在一个api的不一致性，让人很容易搞混。这是因为[start:end]运算符与[index]运算符在一个slice上面进行的操作，一个操作以slice作为基准，一个操作则以slice所指向的原始数组作为基准。
另外这里的另外一个问题，就使得基于切片来创建子切片无法工作。因而其所能支持的行为，只能支持一级数据的切片
slice所指向的数组，可以通过append，copy等操作来进行扩展。
注意到这里有个容易出问题的地方，即对一个slice进行append操作所返回的slice所指向的数组，有可能是之前的数组，也有可能是新的数组。
如果append之后返回的slice指向的是新的slice，则我们在这个slice上的修改，不会反应到直线append之前数据的slice中去。
这其实是一个很容易出错的点，因为slice的行为不一致。在有些场景下，这些slice共享数组的修改，有些场景下，又不共享:
```go
package main

import (
  "fmt"
)

func main() {
  b := make([]int, 5, 10)
  for i := 0; i < len(b); i++ {
    b[i] = i
  }

  printSlice(b)

  c := b[:1]                    //创建切片，引用b所指向的数组的 0:1 个元素
  fmt.Printf("c0: %v", c[0])    //[index]操作符，返回以c切片begin(这里是0)为开始的下标的值

  printSlice(c)

  d := c[2:4]                   //创建切片，引用c所指向的数组的 2:4 个元素。注意到c所指向的数组与b所指向的数组是相同的，因而c[2:4]与b[2:4]所返回的切片所指向的东西是相同的。
  fmt.Printf("d0: %v", d[0])

  printSlice(d)

//for i := 0; i < 1; i++ {      //当append的元素很少时，b所指向的数组不需要重新进行分配，因而当b发生修改时，能够反应到c与d身上
//  b = append(b, i)
//}
//
//b[3] = 99

  for i := 0; i < 100; i++ {    //当append的元素很多时，b所指向的数组需要重新进行分配，因而当b发生修改时，不能够反应到c与d身上。
    b = append(b, i)            //因为c，d所指向的数组与b所指向的数组已经不是同一个数组
  }

  b[3] = 99

  printSlice(c)
  printSlice(d)
  printSlice(b)
}

func printSlice(s []int) {
  fmt.Printf("slice: %v, %d, %d\n", s, len(s), cap(s))
}
```
具体可以参考下面的文章
https://blog.go-zh.org/go-slices-usage-and-internals
猜测golang采用这种设计的主要原因，是为了操作数组的灵活性以及效率。其能够支持将一个子数组作为一个普通数组来进行操作。这种feature是std，java都没有的。
但是为了这种操作的效率，只能采用类似引用的语义，而不能向python那样子直接使用一个不可变的list，最终推演的结果就是形成上面的设计。golang数组的设计是否合理是待商榷的事情了。

## 指向指针的指针 && golang的设计哲学
golang与java, python等语言一个重要的不同之处，是在语言中保留了C语言指针的含义
一般而言，golang的指针与java，python等语言的引用的地位是相类似的，但是保留了指针的含义
更加具体地，golang支持类似C语言中指向指针的指针的用法
比如说下面的代码，我们可以通过指针的指针来判定指针本身的值是否发生了变化
注意到像interface这种类型本质上也是一个指针，所以下面例子中errRef实际上也是指向指针的指针的
``` go
func reportMetrics(reqRef **http.Request, errRef *error) {
  if *reqRef != nil {
    fmt.Printf("req no nil")
  }
}

func main() {
  var req *http.Request
  var err error
  defer reportMetrics(&req, &err)
  req, err = http.NewRequest("POST", "http://127.0.0.1", bytes.NewBuffer(nil))
  if err != nil {
    return
  }
}
```
注意到这种语言特性在java还有python中都是不存在的，这些语言中没有指向引用的引用这种特性
这也部分说明了golang语言中为何不将指针这种语言特性给索性去掉，因而其的确能够提供比其他语言更好的一些表达特性

这个例子中很大程度上说明了golang的设计哲学
golang很大程度上面是作为c语言的改良版本而进行设计的，其设计目的很大程度上是沿用了c语言的哲学与思路，主要修正了c语言的内存访问问题，以及增加了并发的访问特性。
因而golang的值访问语义基本上是与c语言保持一致的，slice切片的设计很大程度上也是与c语言的思想是相一致的
其中的一项证据是golang里面没有提供类似继承这样子的语言特性，因为语言的发明者认为这些特性与c语言的设计哲学是相违背的
还有一项证据是package的包特性，似乎比较鼓励一个包中的代码逻辑拆分，其实也是和c语言的风格都是相类似的
所以使用golang的风格与思路很大程度上应该将其看成一种不能访问底层内存的c语言会更加合适一些
采用这种设计的其中一个想法，估计是希望从c、c++语言的群体中去迁移市场，从而达到与java进行抗衡的这样子一个商业目标

## 带receiver的函数对象调用
golang支持调用函数对象时，携带receiver，如下面例子所示
```go
type A struct {
  Mem1 int
}

func (a *A) foo() {
 fmt.Printf("%d", a.Mem1)
}

func main() {
  a := &A{}
  a.Mem1 = 200
  f := a.foo
  f()                   // 输出200
}
```
## string编码
在golang中，string与byte[]是相同的东西。这种设计与c, c++的设计是相同的。
在golang中要表示一个unicode字符串，需要使用rune类型。rune实际上是int32的别名
更加具体的描述可以参考:
https://blog.golang.org/strings

## 不可变的string
golang中的string虽然模仿了c++中的string，但是有一个很大的区别，是其是不可变对象
而在c++中的string则是可变对象

## 包/模块
golang的包以及模块的概念于python，java这类语言相类似，但是有一些重要的区别。
我们先给出一个定义，一个模块是指其他程序能够通过名字来进行引用的单位，这个概念与文件进行区分
文件是用于程序员拆分管理代码的工具，是复杂度管理工具，而模块则是站在代码使用者的角度的概念
在python以及java中，一个模块是于一个文件直接相对应的。在这些语言中，不允许同一个模块的代码拆分到不同的文件中。
也就是说，这些编程语言中没有给与程序员这些方面的自由
golang的一个模块以及文件的拆分提供了相对自由的方案。golang中的模块对应与一个目录，由目录中的若干个go文件共同组成一个模块
所以在golang中是无法单独import一个文件的，只能import一个目录。
这种方案的缺点在于对于模块与文件存在一一对应关系的时候(不幸地这恰恰是绝大多数的情况)，在golang中仍然需要定义一个文件夹，比较繁琐
所以golang 包的这种设计是否是正确的，目前看起来仍然值得商榷
注意到c语言的编程风格中其实这种方式是很常见的。这也是golang是c语言的一个改良版本的另一个证据
