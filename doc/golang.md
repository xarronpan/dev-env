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
golang的一个模块(按照上文的定义，而不是golang中module的定义)以及文件的拆分提供了相对自由的方案。golang中的模块对应与一个目录，由目录中的若干个go文件共同组成一个模块
所以在golang中是无法单独import一个文件的，只能import一个目录。
这种方案的缺点在于对于模块与文件存在一一对应关系的时候(不幸地这恰恰是绝大多数的情况)，在golang中仍然需要定义一个文件夹，比较繁琐
所以golang 包的这种设计是否是正确的，目前看起来仍然值得商榷
注意到c语言的编程风格中其实这种方式是很常见的。这也是golang是c语言的一个改良版本的另一个证据

在golang中，上文所定义的模块，在golang中的名称是package。而golang的module的概念是若干个package的集合

## 面向对象编程
golang中并没有直接支持面向对象编程的概念，但是给出了能够实现面向对象编程含义的机制
利用这些机制，在golang中能够很容易按面向对象编程的风格组织代码。
更加具体地说，面向对象编程的特性分为几项独立的特性:
(1) 数据与方法的绑定与封装
    golang中通过receiver与函数绑定的语法糖来实现的。这样子golang中支持了类似c，c++中通过 p.Func()的方式来调用代码的写法
```go
type Foo struct {
}

func (c *Foo) Func () {
}

int main() {
  c := &Foo{}
  c.Func()
}
```
   支持这种写法的其中一个原因，是父类子类在代码的使用上，当函数签名是相同的时候，除了对象的创建位置外，其他地方都不需要进行修改
比如在c语言中，若要求类型安全, 则父类和子类的函数名称都是不同的，这就造成了当父类修改成子类时，全部的函数代码都需要进行修改的问题
注意这里提到的点和多态还不太相同。即使在没有多态的情况下，替换一个父类到子类需要修改很多代码也是不可以接受的
```c
//父类的函数
int ParentFunc(Parent* parent, int param1, int param2)

//子类的函数
int ChildFunc(Child* child, int param1, int param2)
```
  能够解决这个问题的另外一个方案是类似于c++中的重载函数的方案。但是这种方案Func(p, )的可读性还是不如 p.Func()的好，因为作为接受消息
的对象的位置与其他的参数是在语法上给明确区分开来的

(2) 子类拥有父类的数据还有方法，并且能够增加自己的数据以及方法，以及覆盖父类方法的能力
    如果golang中没有额外的语言特性，则实现这项语言特性，golang需要使用组合以及代理的方式编写代码
```go
type Parent struct {
}

func (p *Parent) Func () {
}

type Child struct {
  parent *Parent
}

func (c *Child) Func () {
  //通过代理的方式来实现子类拥有父类方法的功能
  c.parent.Func()
}
```
可以看出，这个方案已经是在类型安全的前提下, 能够实现该需求的最简单方案了, 通过代理转发的方式，代码的冗余度是最低的方案了
假设golang不是类型安全的话，可以通过将Child的struct直接塞入到Parent的Func函数中实现。在c语言中的确可以采用这种写法。
这种写法的问题一是类型不安全，而是不能够支持多继承的结构

我们可以发现这种方式其实已经能够实现面向对象语义中子类拥有父类数据还有行为的特性了，但是主要存在的问题在于代码的冗余
每继承一个父类，都需要增加一大堆的代理方法，在语言的层面上面讲，对于这种常见的需求带来那么多的冗余代码，肯定是不够理想的
所以在golang中增加了一种语法糖专门应对这种需求，减少代码的冗余度，这样子 子类拥有父类数据还有方法的问题就能够很好地被解决
```go
type Parent struct {
}

func (p *Parent) Func () {
}

type Child struct {
  Parent //通过这种写法，表示Child拥有父类的全部方法，这样子就不需要编写很多的代理转发的代码
}
```
同时Child能够覆盖父类中的方法，从而支持按差异编程的能力
```go
type Parent struct {
}

func (p *Parent) Func () {
}

type Child struct {
  Parent //通过这种写法，表示Child拥有父类的全部方法，这样子就不需要编写很多的代理转发的代码
}

// Child定义了自己的Func方法，能够覆盖Parent的方法
func (c *Child) Func () {
}
```

(3) 多态
多态的本质是客户端代码能够通过同一个接口能够访问不同的对象。
这点能力其实interface的语言特性已经进行了支持，所以golang认为不需要更多的特性来完成这个需求
为了让golang支持面向对象编程语言中子类可以拥有父类的函数，并且能够对这些函数进行修改，结合(2)中给出的设计，
golang应该需要支持interface能够指向一个子类，而子类的方法都是从父类那里继承过来的写法。
```go
type ParentInf interface {
  Func(param int)
}

type Parent struct {
}

func (p *Parent) Func (param int) {
}

type Child struct {
  Parent //通过这种写法，表示Child拥有父类的全部方法，这样子就不需要编写很多的代理转发的代码
}

int main() {
  var pi ParentInf
  pi = &Child{}
  pi.Func(100)  //interface指向Child所继承下来的方法，如果golang的设计考虑了支持OO这种特性，则是应该给与支持的
}
```

(4) 子类能够修改父类的行为
这种行为其实在golang中可以通过让子类去重新设置一个函数对象来进行实现。特别地，我们提到过golang中函数对象是可以和receiver进行绑定了
要实现这个需求就更加简单了


下面的代码展现了在golang中如何去模拟一个Child继承了Parent还有Parent2，并且改写接口代码，以及template method的示例
```go
package main

import "fmt"

type ParentInf interface {
	Func1(param1 string)
	Func4(param1 string)
}

type ParentInf2 interface {
	Func5()
}

type Parent struct {
	mem1    int
	Overide func(int)
}

//Func1不会被子类改写。但是Func1会调用一个内部方法func3，
//func3会被子类改写。我们通过Overide方法被子类改写来模仿这种行为
func (p *Parent) Func1(param1 string) {
	fmt.Println("Func1")
	p.Overide(100)
}

func (p *Parent) func3(param1 int) {
	fmt.Println("Parent Func3")
}

//Func4会被子类改写，并且Func4是ParentInf中的一部分, 这就验证了golang能够实现父类的public virtual函数被改写的行为
func (p *Parent) Func4(param1 string) {
	fmt.Println("Parent Func4")
}

func NewParent() *Parent {
	p := &Parent{}
	p.Overide = p.func3
	return p
}

//golang支持非菱形结构的继承结构的代码编写。Child会同时拥有Parent1还有Parent2的方法
type Parent2 struct {
	mem3 int
}

func (p *Parent2) Func5() {
	fmt.Println("Parent2 Func5")
}

type Child struct {
	Parent
	Parent2
	mem2 int
}

//Func2是Child增加的函数
func (c *Child) Func2(param1 int) {
	fmt.Println("Func2")
}

//func3等于是改写了Parent中的func3函数, 但是需要通过在创建对象时修改Parent的Overide函数对象来实现
func (c *Child) func3(param1 int) {
	fmt.Printf("Child Func3, %d\n", c.mem2)
}

//Child覆写Parent的Func4函数
func (c *Child) Func4(param1 string) {
	fmt.Println("Child Func4")
}

func NewChild(param int) *Child {
	c := &Child{mem2: param}
	c.Overide = c.func3  //实现private virtual函数被改写的行为
	return c
}

func main() {
	p := NewParent()
	p.Func1("abc")

	c := NewChild(200)
	c.Func1("abc")
	c.Func2(2)
	c.Func5()

	var pi ParentInf
	pi = p
	pi.Func1("def")
	pi.Func4("def")

	pi = c
	pi.Func1("def")
	pi.Func4("def")

	var pi2 ParentInf2
	pi2 = c
	pi2.Func5()
}
```

结论:  golang中给出了构造面向对象编程的机制，但是没有在语言层面上给出一个统一的对象的概念，而这些机制又是相对零散的，没有一个整体的概念的
其实方案与javascript，lua等脚本语言的方案是相类似的。
这点其实进一步印证了golang是c语言的改良版本的看法。其坚持只给机制，而不给整体解决方案的风格。其实包括c语言中设计得很烂的头文件，
也是属于这种设计风格的一个例子。是否是一个好的方案是值得商榷的, 因为没有整体的概念让人很难进行整体理解和使用。


这里其实也可以推演出面向对象这种技术的本质:
面向对象技术与函数，编程语言相类似，本质上是一种基于类比的使用界面, 能够通过对于自然界中的类别以及行为的关系，快速地理解编程语言提供的特性的行为
(编程语言也是一种基于类比的界面，能够通过人类语言的行为，快速地理解如何操作计算机的指令还有数据)
这种技术本质上是在编程语言层面, 解决开发程序中存在的下列实际需求, 并通过人类容易理解的概念模型来使用编程语言有效地解决这些需求:
(1) 信息隐藏的需求
(2) 模块间的冗余问题。A模块的数据还有函数的逻辑与B模块大幅相同，如果没有额外的语言机制，则会造成需要反复编写冗余代理代码的情况
(3) 调用方无差别地使用若干个模块，并且运行过程中改变行为的需求
(4) 从A模块的数据还有函数的逻辑与B模块大幅相同所延申出来的A模块与B模块间有细微差异，希望通过尽可能少的冗余来表达这种差异

所以从这种角度上面来看，面向对象语言从易用性的角度上面来讲，是一种优秀的技术方案。

## 错误处理
在golang中返回错误有两种不同的风格
(1) 创建自定义的错误类型，以及错误对象，并且将额外的错误信息放入到错误对象中
在这种场景下，错误的使用者需要通过下向转型来判断是什么错误，并且在将对象转换成具体的错误类型之后，再通过接口获取具体的错误信息
这种方案是最为经典的方案，与java exception这类方案的错误数据表示是相类似的, 缺点是有时你需要定义较多的自定义错误类型，在一些比较轻的场景下可能不太方便

(2) 返回一个特定的错误对象值来区分不同的错误
这种方案其实很大程度上等价与一个错误码，其实并不是那么好的一种错误处理方式
其实是一种应该被完全抛弃掉的错误处理方案, 但是golang中没有具体对错误进行分类的语法，而需要自己去下向转型, 代码编写其他其实是很别扭，远远没有java的异常含义清晰。
但是目前golang不少的标准库都采用这种返回错误的方式
在有些场景下，你希望这种风格的错误能够往上进行传递，但是这是你又没有对这个错误增加信息的能力。此时可以考虑使用 github.com/pkg/errors
```go
import (
   "database/sql"
   "fmt"

   "github.com/pkg/errors"
)

func foo() error {
   return errors.Wrap(sql.ErrNoRows, "foo failed")
}

func bar() error {
   return errors.WithMessage(foo(), "bar failed")
}

func main() {
   err := bar()
   if errors.Cause(err) == sql.ErrNoRows {
      fmt.Printf("data not found, %v\n", err)
      fmt.Printf("%+v\n", err)
      return
   }
   if err != nil {
      // unknown error
   }
}
```
注意到这种风格的错误不使用于定义一个很清晰的api的场景，因为这种错误会对外暴露底层的程序细节，以及导致错误与api的描述不在一个抽象层次的问题
(错误本身也是api的一部分!，因而给用户的概念应该是与api是用户能够整体进行理解的)
这种用法更加适合于模块内部的较为轻的错误处理写法
具体可见: https://medium.com/@dche423/golang-error-handling-best-practice-cn-42982bd72672
