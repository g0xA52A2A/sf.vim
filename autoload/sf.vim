function! sf#Populate(cmd, bang, args) abort
  let [prg, efm] =
    \ { 'grep' : [&grepprg, &grepformat ]
    \ , 'make' : [&makeprg, &errorformat]
    \ }[a:cmd]

  let args = expandcmd(a:args)
  let prg  = split(prg, '\$\*', 1)
  let exec = len(prg) == 1 ? join(prg) . ' ' . args : join(prg, args)

  if exists('#QuickFixCmdPre#' . a:cmd)
    execute 'doautocmd QuickFixCmdPre' a:cmd
  endif

  let qflist = getqflist(
    \ { 'efm'   : efm
    \ , 'lines' : systemlist(exec)
    \ })

  call setqflist([], ' ', extend(qflist, {'title' : exec}))

  if empty(a:bang)
    silent! cfirst!
    silent! cnext!
  endif

  if exists('#QuickFixCmdPost#' . a:cmd)
    execute 'doautocmd QuickFixCmdPost' a:cmd
  endif
endfunction

function! sf#Context() abort
  call setqflist([], 'r', {'context' : map(getqflist(), "v:val['text']")})
endfunction

function! sf#Reduce() abort
  call setqflist([], 'r', {'items' : filter(getqflist(), "v:val['valid']")})
endfunction

function! sf#Pager(message) abort
  execute '!clear &&' get(g:, 'sf_pager', 'less -+FX') '<<<'
    \ shellescape(join(a:message, "\n"), 1)

  " See https://github.com/vim/vim/issues/7562
  if !empty(expand('<amatch>'))
    !tput smkx
  endif

  redraw!
endfunction
