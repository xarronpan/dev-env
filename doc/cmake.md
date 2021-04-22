一 核心概念

在使用cmake作为c/c++的构建工具的过程中，理解cmake中一些核心的概念，有助于高效地使用该工具



1 跨平台编译

   cmake首先要解决跨平台编译源码，安装程序的问题。对于c/c++程序而言，由于执行的平台不同，很多场景下都需要在特殊的平台上进行编译，才能让程序给工作起来。

这些环境的特殊性，包括了 二进制指令集的不同，api接口的不同，以及构建工具链的不同。哪怕是在类Unix的平台中，make，makefile的版本也是很多样的。这就造成了一个开源的c/c++库或者程序，哪怕是遵循相同的posix api规范来进行编写，

能够在不同的平台上面进行编译，但是最终要进行源代码安装的时候，仍然需要解决不同平台上编译工具链异构的问题。在cmake之前，其实大家是使用 autoconf 来解决这个问题的。

由于autoconf 设计得实在是太烂了，所以目前逐步被cmake所取代。

   cmake为了使得项目代码能够在全部的unix平台，目前甚至在windows平台上面能够进行编译，所以只能自己封装了一层命令层，去屏蔽操作系统，编译器选项等平台相关的细节。然后在更高的层次上，去构建了一个能够控制依赖生成关系的命令体系、



   cmake区别于makefile的其中一个差别，就是提供了项目的配置能力。cmake统一提供了对项目参数进行配置的ui界面，已经命令行参数选项体系，供源程序包来进行使用。这点能力其实原来也是autoconf所提供的。所以cmake基本上的定义就是autoconf这类源码

构建工具的替换品。   



结论:

    cmake是autoconf的替代品。

    上面的分析进一步得出的结论，是cmake未必完全适合于后台的编译构建。因为在后台研发的场景中，平台总是单一的。而cmake在引入第三方库的工作，由于需要考虑跨平台的情况，需要做的事情实质上比Makefile在编译器选项中增加两个编译参数来得更为复杂。

但是对于需要进行跨平台编译的sdk系统，cmake是一个优秀的选择。此外，Makefile相对轻量级，但是难以应对非常复杂的项目编译需求。比如当项目需要进行复杂的配置，复杂的依赖管理时，Makefile由于只是一个非常简单的依赖管理工具，就显得力不从心。

而cmake由于具备正规的脚本控制流管理能力，以及清晰的命令定义，以及一系列深思熟虑的机制，比如子目录，包，模块，能够更加好的对大型的复杂构建项目进行支持。简单地说，构建需求越是复杂，越是适用与使用cmake来进行构建。这点关系就像在对系统进行运维的时候

简单的Shell脚本 Vs 正规的Python脚本的差别



2 cmake脚本的控制流/项目编译命令

   cmake的高层概念，是可以通过一个类似shell脚本的控制流，去控制项目编译命令的执行。而项目编译命令则有能力去指定代码与目标之间的关联关系。

 脚本的执行流程与标准的程序执行语言相同，而不会像Makefile中的控制流程中定义得不清不楚，非常难以大规模进行使用。

 cmake会内置提供一些基础的项目编译命令，能够让用于通过简单的几行代码，就能做到Makefile中原本需要较多的代码才能做到的事情，而且能够屏蔽很多的底层细节，比如如何去创建.o，创建静态库，以及动态库等。

 灵活的能力则由if for whille等控制指令来进行控制。因为这些指令能够允许进行任意的流程控制，所以理论上不论多么复杂的项目配置关系都能够被实现。虽然如此，这里需要提到的一个点，是在cmake这类DSL中去大量使用控制指令，应该是一个anti-pattern。

 此外由于cmake封装了操作系统的底层细节，为了能够实现操作系统的很多命令能力，所以cmake脚本所提供的控制流与shell脚本很像，也是意料中事。

   cmake的脚本的特点与shell这类脚本的特征相同，首先是允许非常简单的变量名称引用。这是因为在进行编译构建时有大量的变量名称引用的需求。其次一个特征是变量都是list。这也是编译领域的需求不同于shell通用脚本需求的一个特点。

 而cmake不需要当成交互式的命令被执行，因而不需要向shell脚本这样子去对空格的数目做特殊的解释，因而能够降低构建脚本的编写难度。上面的各方面原因，导致了cmake开发了自己的脚本语法，而没有直接采用类似shell，python这类已有的脚本作为控制流控制语言。



3 子目录

   cmake中子目录的用途，对应于Makefile中递归调用子项目Makefile的能力。这种需求实际上对应着希望对构建脚本进行拆分，每个子脚本只对应大项目中的一个子目录进行构建，从而降低整体构建复杂度的需求。

虽然这类需求理论上也是可以通过提供函数的统一机制来进行实现，但是由于是热点需求，cmake由理由去提供一种让使用者更为简单能够做到想要事情的方式。为了支持这种能力，变量的生命周期这些非常底层的设计，也会与子目录相关联的。



4 包 (findpackage)

    与子目录机制相同的还有包机制。包本质上的想法就是将项目所依赖的外部包，给引入到项目之中。由于是一个非常热点的需求，所以cmake中也专门设计了对应的解决方案，来完备地解决第三方包加入到cmake项目的规范。cmake这种管理方式对于大型的项目，复杂的包依赖场景有相当地好处。其带来的问题就是第一次进行使用cmake来引入第三方包时，哪怕是一个很简单的需求，也需要知道cmake引入第三方包时的标准行为，没有Makefile设计得那么自由散漫。

     在cmake的best practice中，FindPackeage的cmake需要解决的问题，是找到第三方包的二进制程序，include文件以及library，版本等信息。而具体的使用包的逻辑，应该放到模块中进行声明。

     具体可以参考下面两个例子：

     https://github.com/ttroy50/cmake-examples/tree/master/04-static-analysis/cppcheck-compile-commands

     https://github.com/ttroy50/cmake-examples/blob/master/04-static-analysis/cppcheck/cmake/analysis.cmake

     比如第二个例子中，通过FindPackege找到了cppcheck，但是使用cppcheck的相关cmake脚本还是通过一个独立的宏来进行包装的。也就是在cmake的最佳实践中，找到引入包，以及使用包应该采用独立的代码来进行编写。除非使用包的代码是与包紧密相连的，如第一个例子所示。

     在第二个例子中，cppcheck的使用脚本与项目代码关系更加紧密，因而放到了独立的analysis.cmake中来实现。例子二中还给出了当子项目中需要引入公共模块时的合理做法，就是去引入父级目录下面的公共cmake脚本。其实在使用makefile来编译程序时，我就有过疑问这类需求应该如何去实现。想法是相类似的。这样子做的原因分析如下: 因为这类脚本不属于任意一个项目，所以应该放在公共目录下; 而将项目拆分成子目录的本质原因，只是希望上层目录不需要去得知很多下层目录的构建细节，从而使得构建脚本能够得以被有效进行分解。

     第二个例子也展现了父目录与子目录之间如何通过变量来进行通信。一般而言，父目录调用子目录时，会将父目录能够见到的变量传递给子目录。然后子目录一般是根据这些变量来进行工作，而父目录见不到子目录的变量设置。

     这是因为公共的东西大概率是放在上级目录的，因而上级目录公共的东西，包括变量定义等能够传递到子目录中是热需求。而子目录大概率是完成构建更加细节部分的工作，因而父目录不太需求见得到子目录中的东西。

     在子目录中，通过set PARENT scope命令，能够在子目录设置的变量在父级目录中可以看得到。



5 模块(module)

   cmake的模块通过include的方式进行引入，目标就是与程序模块的设计理念相类似，就是子程序的复用。

   虽然向子目录，包等机制本质上，也都可以通过module的方式来实现，但是我们在使用DSL的一个好习惯，就是尽可能使用DSL中更加定制化的功能。这样子DSL的长度能够更短。

  include语句的作用与c语言中的include语句的作用像类似，就是可以去引入一个模块中所定义的函数或者宏来进行处理。函数与宏的差异，可以见第6小节的分析



6 函数 vs 宏

   函数和宏都是cmake用于复用构建代码的机制。函数有自己的执行范围，而宏则类似与c/c++的情况，是简单的代码替换。因而在宏中引入的参数，不是真正的变量，因而不能直接通过if等语句进行引用。

   此外宏中 set Parent Scope 设置的是 调用这个宏脚本所属的上级目录的变量，而函数中  set Parent Scope 设置的是 调用这个函数所属脚本的变量，因而如果存在设置调用脚本父级目录的需求，宏会更加合适一些

  具体的差别可以看下面的文档。

  https://cmake.org/cmake/help/v3.19/command/macro.html

  https://cmake.org/cmake/help/v3.19/command/function.html



7 属性

   属性是cmake内置能够控制构建过程的变量。属性可以在设置在不同的范围(scope)中，用于定义不同的构建对象的行为。

   比如说作用在目标上的target的属性，影响的是target的构建行为；作用在目录上的dictionary属性，则影响的是在dictionary中进行构建时的行为。

   cmake定义的属性可以见:

   https://cmake.org/cmake/help/v3.19/manual/cmake-properties.7.html#manual:cmake-properties(7)

   这些属性可以通过 set_propreties 来进行设置，通过 get_properties来进行获取。

   其实由于cmake所能够控制的编译行为选项非常非常多，可以认为这些控制参数，只能通过在不同的对象中进行标记来指定整个构建行为的参数。否则可能会由于过于复杂，导致指定构建行为参数失控了。



二 学习使用

https://github.com/ttroy50/cmake-examples

上面的链接包括了cmake的经典使用范例。这个例子中的每个例子都需要彻底吃透



有用功能: 

make VERBOSE=1  //执行make的时候，输出详细的make 输出信息，用于调试参数是否存在问题



三 包管理

1 conan

conan是一个c/c++的二进制包管理工具。使用二进制包管理的优势在于进行构建时不需要进行编译，只要选定了平台，指令架构以及编译器等参数，就能获取到对应的二进制包，而不需要进一步进行编译，因而构建速度快，构建流程相对稳定。

其缺点是若用户有对源代码包较多的定制化需求，则二进制包并不能够满足对应的要求，灵活性较差。

所以类似conan这种二进制包的管理工具，更加适用与作为一个完成二进制进行发布的产品。比如典型的互联网客户端产品、服务器端产品

conan的管理功能已经做得非常的完备，主要包括的事情就是对二进制包进行打包，上传，以及下载，版本控制，依赖控制等功能。

所以可以考虑让QA部门对该包管理工具进行支持，而不需要自己再去发明轮子

https://docs.conan.io/en/latest/introduction.html



2 hunter




