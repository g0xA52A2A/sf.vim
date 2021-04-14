augroup sf
  autocmd!
  autocmd QuickFixCmdPost make call sf#Context()
  autocmd QuickFixCmdPost make
    \ if get(g:, 'sf_reduce', 1)
    \ |   call sf#Reduce()
    \ | endif
  autocmd QuickFixCmdPost make
    \ if v:shell_error
    \ |   Context
    \ | else
    \ |   execute get(g:, 'sf_ok', "echomsg 'OK'")
    \ | endif
augroup END
