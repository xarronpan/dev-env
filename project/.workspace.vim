autocmd BufWritePost * silent !(
      \ cd ~/git/zixia &&
      \ rsync -avz --delete --exclude=".*" 
      \ --exclude="*.o" 
      \ --exclude="/tags" 
      \ --exclude="/build" 
      \ --exclude="/output" 
      \ . 14.116.173.26:~/git/zixia
      \ >> .rsync.log 2>&1 &)

