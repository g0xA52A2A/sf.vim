command! -bar Context
  \ call sf#Pager(getqflist({'context' : 0})['context'])

command! -bar -bang -nargs=+ -complete=file Grep
  \ call sf#Populate('grep', <q-bang>, <q-args>)

command! -bar -bang -nargs=* -complete=file Make
  \ call sf#Populate('make', <q-bang>, <q-args>)
  \ | if exists('g:sf_remake_key')
  \ |   execute 'nnoremap <silent>' g:sf_remake_key ':Make<bang> <args><CR>'
  \ | endif
