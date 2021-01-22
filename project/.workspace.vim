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

autocmd BufWritePost * silent !(
      \ cd `git rev-parse --show-toplevel`;
      \ rsync -avz --delete --exclude=".*" 
      \ --exclude="*.o" 
      \ --exclude="/tags" 
      \ --exclude="/build" 
      \ --exclude="/output" 
      \ . 14.116.173.152:~/git/zixia
      \ >> .rsync.log 2>&1 &)
