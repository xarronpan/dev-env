1 go mod

golang1.11 之后引入了go mod，用于管理golang包的版本。

golang包的管理方案除了下面一点较为特殊之外，与其他的包依赖管理系统基本上都是相类似的。

包括能够自动下载包，指定下载包的版本。下面重点描述go mod的特殊之处

(1) 基于源代码的发布

  golang模块的发布都是基于源代码的方式发布的。所以我们会发现在golang里面没有编译静态库，动态库的命令

  使用go get 命令之后，golang会在客户端本地编译基于源代码方式发布的golang模块，然后再在go build的时候与这些编译好的模块进行链接

  这个方案其实与c/c++中hunter的方式是相类似的

  由于模块是基于源代码的方式发布的，所以获取代码最为简单的方式是依赖与git。而对代码版本进行区分的最简单的方式就是使用git的tag来区分版本

  go mod的包发布可以见下面的连接:

  https://golang.org/doc/modules/developing

(2) 版本约定

   大版本号不一定能够保证api兼容，小版本一定保证api兼容，patch版本号保证api版本不发生变化

    这个版本方案，就是的golang在出现菱形包依赖的时候，能够解决包版本兼容性的问题。具体可以看到下面的分析

    https://golang.org/doc/modules/version-numbers

(3) 菱形包依赖解决方案

    当正在编辑的模块A 依赖与 B、C模块，而B、C模块都依赖与D版本的模块，而B、C模块假设依赖的包D的版本号

    (a) 大版本号是相同的，则此时使用小版本号更大的版本即可保证兼容

    (b) 大版本号是不同的，则此时golang约定两个包必须在不同的包路径下，因而可以认为是两个独立的包，所以该问题就能够被进行解决。

    https://blog.golang.org/v2-go-modules



2 go slice

golang的slice与其他语言中的数组在设计上面差别比较大。

主要的结论，是slice是静态数组或者是动态数据的引用或者指针，其本身所指向的数组在一旦创建之后，是不会发生变化的。这点和c++中的vector其实是很像的。

slice的[start:end]获取新slice的操作符，每次都会以slice所指向的数组为参考重新生成另外一个切片。

而[index]运算符，则是以当前slice的start，end的位置来访问数组的数据。

这里就存在一个api的不一致性，让人很容易搞混。这是因为同样是在一个slice上面进行的操作，一个操作以slice作为基准，一个操作则以slice所指向的原始数组作为基准。

另外这里的另外一个问题，就使得基于切片来创建子切片无法工作。因而其所能支持的行为，只能支持一级数据的切片

slice所指向的数组，可以通过append，copy等操作来进行扩展。

注意到这里有个容易出问题的地方，即对一个slice进行append操作所返回的slice所指向的数组，有可能是之前的数组，也有可能是新的数组。

如果append之后返回的slice指向的是新的slice，则我们在这个slice上的修改，不会反应到直线append之前数据的slice中去。

这其实是一个很容易出错的点，因为slice的行为不一致。在有些场景下，这些slice共享数组的修改，有些场景下，又不共享:



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

c := b[:1]                            //创建切片，引用b所指向的数组的 0:1 个元素
fmt.Printf("c0: %v", c[0])    //[index]操作符，返回以c切片begin(这里是0)为开始的下标的值

printSlice(c)

d := c[2:4]                           //创建切片，引用c所指向的数组的 2:4 个元素。注意到c所指向的数组与b所指向的数组是相同的，因而c[2:4]与b[2:4]所返回的切片所指向的东西是相同的。
fmt.Printf("d0: %v", d[0])

printSlice(d)

//for i := 0; i < 1; i++ {       //当append的元素很少时，b所指向的数组不需要重新进行分配，因而当b发生修改时，能够反应到c与d身上
//    b = append(b, i) 
//}
//
//b[3] = 99

for i := 0; i < 100; i++ {       //当append的元素很多时，b所指向的数组需要重新进行分配，因而当b发生修改时，不能够反应到c与d身上。
    b = append(b, i)              //因为c，d所指向的数组与b所指向的数组已经不是同一个数组
}

b[3] = 99

printSlice(c)
printSlice(d)
printSlice(b)
}

func printSlice(s []int) {
    fmt.Printf("slice: %v, %d, %d\n", s, len(s), cap(s))
}



具体可以参考下面的文章

https://blog.go-zh.org/go-slices-usage-and-internals



猜测golang采用这种设计的主要原因，是为了操作数组的灵活性以及效率。其能够支持将一个子数组作为一个普通数组来进行操作。这种feature是std，java都没有的。

但是为了这种操作的效率，只能采用类似引用的语义，而不能向python那样子直接使用一个不可变的list，最终推演的结果就是形成上面的设计。golang数组的设计是否合理是待商榷的事情了。



