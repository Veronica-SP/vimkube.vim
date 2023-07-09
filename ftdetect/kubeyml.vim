autocmd BufNewFile,BufRead,BufEnter *.yml, set filetype=yaml
autocmd BufNewFile,TextChanged,TextChangedI * call kubeyml#DetectKubernetes()

function! kubeyml#DetectKubernetes()
  if !did_filetype() && &ft == '' && getline(1) =~# '^apiVersion:'
    set filetype=yaml
  endif
endfunction
