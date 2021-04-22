vim中的很多功能都依赖与ctags的生成。比如在ycm所依赖的信息不全的时候，ctags仍然可以进行使用

我们依赖 ludovicchabant/vim-gutentags 来生成ctags

由于在有些项目中，引用的第三方文件很多，有可能会造成ctags话大量时间生成无用的符号，所以需要定制ctags调用的参数



若需要特殊的ctags配置时，可以在项目的目录增加 .gutctags，输入下面的配置: 

.gutctags:



--exclude=third-party/*
--exclude=build/*
--exclude=.cache/*
--exclude=.vscode/*
--exclude=.git/*
--exclude=.gitignore/*
--exclude=.gitmodules/*
--languages=C,C++,Protobuf
-R



