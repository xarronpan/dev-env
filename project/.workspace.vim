autocmd BufWritePost * silent !(
      \ cd ~/projects/zixia &&
      \ rsync -avz --delete --exclude=".*" 
      \ --exclude="*.o" 
      \ --exclude="/tags" 
      \ --exclude="/build" 
      \ --exclude="/output" 
      \ . 14.116.173.152:~/projects/zixia
      \ >> .rsync.log 2>&1 &)

