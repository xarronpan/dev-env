set expandtab softtabstop=4 tabstop=4 shiftwidth=4

autocmd BufWritePost * silent !(
      \ cd ~/projects/zixia &&
      \ rsync -avz --delete --exclude=".*" 
      \ --exclude="*.o" 
      \ --exclude="/tags" 
      \ --exclude="/build" 
      \ --exclude="/output" 
      \ . 14.116.173.152:~/projects/zixia
      \ >> .rsync.log 2>&1 &)

function! s:BuildCmd(app)
  let l:cmd = "ssh -t 14.116.173.152 \"cd projects/zixia;./build.sh " . a:app .";exit\""
  call asyncrun#run('',{},l:cmd)
endfunction

command! -bang -nargs=1 DoBuild call s:BuildCmd(<q-args>)
cnoreabbrev Build Gcd <bar> DoBuild
