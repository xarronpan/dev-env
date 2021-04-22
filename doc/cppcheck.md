cppcheck可以通过静态分析，检查出c++代码中存在的高危代码问题。

虽然相关的问题也同样可以通过santinize等工具来进行检查，但是静态检查方案的优势在于能够直接发现代码的问题，从而减低bug排查的时间

而snatinize的方案仍然需要一些的定位时间。所以虽然cppcheck等方案不能排查出所有的问题，但即使只能够排查出部分的问题，仍然是值得重视的方案

目前使用cppcheck靠谱的方案，就是在vim中直接通过AsyncRun命令，运行cppcheck的执行结果，并且在quick fix window中像检查编译错误一样，获取有问题的代码位置 (cpp check 的错误fmt和gcc等的编译错误是一致的)。

目前像ale，syntastic等插件也集成了cppcheck的功能，但是基本上不实用。ale的检查会同时以单个文件，整个project来运行cppcheck，但是整个project的检查结果会覆盖单个文件所产生的结果。

而cppcheck有个坑爹的问题，就是单个文件 (后者项目目录)的检查结果与整个project (依赖与compile_db.json)的检查见过不一定是一致的，会导致一些非常简答明显的错误都不能被发现。

此外ale每打开一个文件之后，都会对整个project进行cppcheck检查

并且流程上是不可控的。所以目前在vim的后台环境中，cppcheck的vim插件集成方案基本上都是不靠谱的。

cppcheck的详细使用，可以见manual:

http://cppcheck.sourceforge.net/manual.pdf



下面列出一些目前使用上已经被发现出的问题，避免问题被遗漏

1 单个文件与整个project都需要进行检查

  cppcheck可以指定对代码目录，或者以compile_db.json的项目信息方式来对源代码进行检查。

  而这几种检查方式所输出的结果不一定是一致的。这是因为cppcheck与严格的编译程序不同，总是希望能够只有部分源代码的情况下能够输出结果。所以这也导致了输出的结果与对应的配置信息有关

   所以为了高效地对文件进行检测，尽可能多地发现问题，结论是目前至少项目目录，以及整个project都需要进行检查，才不会漏掉问题。

 我实验发现过对于 双次 delete的问题，如果被delete的对象是依赖与一个C++的自定义类定义，则需要使用project的方式才能给检查出来

 但是一个简单的内存泄露问题，project的方式发现不了，而使用目录的方式才能够被发现

  比如 cppcheck project_dir 检查一次，然后cppcheck --project=build/compile_db.json检查一次



2 小心#error 等预编译头

  cppcheck会对头文件的宏的所有可能定义情况都展开进行分析。在有些项目中，比如protobuf中，会定义检查GOOGLE_PROTOBUF_VERSION的版本的检查宏，并且在宏不满足要求的情况下，输出#error宏

  cppcheck遇到#error宏的时候，检查行为就会变得比较奇怪，有可能就直接放弃对后面的代码进行分析了。可能cppcheck还没有聪明到能够认识宏里面的变量条件，并且生成不同的条件来进行分析。

  我们首先要阅读cppcheck中输出的检查信息，看是否后#error相关的信息输出。然后我们人为去指定编译宏的参数。

  具体可以见间manual中有详细说明。比如说以下面的方式去执行代码检查

   cppcheck-D GOOGLE_PROTOBUF_VERSION=10000 --project=build/compile_db.json


