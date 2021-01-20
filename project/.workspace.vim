autocmd BufWritePost *.cc,*.h silent !(
      \ cd `git rev-parse --show-toplevel`;
      \ ctags-universal
      \ --exclude=third-party/* 
      \ --exclude=build/* 
      \ --exclude=.cache/* 
      \ --exclude=.vscode/* 
      \ --exclude=.git/* 
      \ --exclude=.gitignore/* 
      \ --exclude=.gitmodules/* 
      \ --languages=C,C++,Protobuf 
      \ -R .)
