if exists('g:autoloaded_fizzy_completions_php') " {{{
  finish
endif
let g:autoloaded_fizzy_completions_php = 1 " }}}

function! fizzy#completions#php#private_property(_1, _2, type, name, ...) " {{{
  let code = []
  if len(a:type)
    call extend(code, [
          \ '/**',
          \ ' * @var ' . a:type,
          \ ' */'
          \ ])
  endif
  call extend(code, ['private $' . a:name . ';'])
  return code
endfunction " }}}

function! fizzy#completions#php#if_isset(names, ...) " {{{
  let variables = split(substitute(a:names, '^\s\+\|\s\+$', '', 'g'), '\s\+')
  return ['if (isset (' . join(variables, ') && isset (') . ')) {', "\t$0", '}']
endfunction " }}}

function! fizzy#completions#php#return_initialized_property(name, value, arguments, ...) " {{{
  return [
        \ 'if ($this->' . a:name . ' === null) {',
        \ "\t$this->" . a:name . ' = new ' . a:value . a:arguments . ';',
        \ '}',
        \ '',
        \ 'return $this->' . a:name . ';'
        \ ]
endfunction " }}}

function! fizzy#completions#php#ternary_isset(name, expression1, _1, _2, _3, expression2, ...) " {{{
  return ['(isset ($' . a:name . a:expression1 . ') ? $' . a:name . a:expression1 . a:expression2 . ' : null)']
endfunction " }}}
