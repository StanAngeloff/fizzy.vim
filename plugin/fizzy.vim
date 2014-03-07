if exists('g:loaded_fizzy') " {{{
  finish
endif
let g:loaded_fizzy = 1 " }}}

augroup fizzy " {{{
  autocmd!
  autocmd CompleteDone * call fizzy#completions#done()
augroup END " }}}
