if exists('g:autoloaded_fizzy_completions') " {{{
  finish
endif
let g:autoloaded_fizzy_completions = 1 " }}}

function! fizzy#completions#get_patterns() " {{{
  let patterns = []
  if exists('g:fizzy_complete_patterns')
    call extend(patterns, g:fizzy_complete_patterns)
  endif
  if exists('b:fizzy_complete_patterns')
    call extend(patterns, b:fizzy_complete_patterns)
  endif
  return patterns
endfunction " }}}

function! fizzy#completions#get_word() " {{{
  let line = getline('.')
  let column = col('.')

  let end_column = column
  " Read back to the first non-whitespace character.
  while end_column >= 0 && (line[end_column] == '' || line[end_column] =~ '\s')
    let end_column = end_column - 1
  endwhile

  let complete_patterns = fizzy#completions#get_patterns()

  " Walk to the beginning of the line and attempt to match any of the regular expressions
  " associated with a completion.
  let start_column = end_column
  let pattern_column = -1
  while start_column >= 0
    if pattern_column > -1 | break | endif
    for complete_options in complete_patterns
      if pattern_column > -1 | break | endif
      for pattern in complete_options['patterns']
        if pattern_column > -1 | break | endif
        let pattern_column = match(line[0 : end_column], '^' . pattern . '\s*$', start_column)
        " If we have a match, make sure it is preceded by a whitespace character.
        if pattern_column > 0 && line[pattern_column - 1] !~ '\s\|(\|)'
          let pattern_column = -1
        endif
      endfor
    endfor
    let start_column = start_column - 1
  endwhile

  if pattern_column > -1 && pattern_column <= end_column
    return [line[pattern_column : end_column], pattern_column, end_column]
  endif

  " If we failed to match a regular expression, assume we are performing fuzzy completion.
  let start_column = end_column
  " Read back to the first non-word character.
  while start_column >= 0 && line[start_column] =~ '\w'
    let start_column = start_column - 1
  endwhile

  let start_column = start_column + 1
  if start_column <= end_column
    return [line[start_column : end_column], start_column, end_column]
  endif

  return ['', -1, -1]
endfunction " }}}

function! fizzy#completions#done() " {{{
  " If we have no candidates, a different completion has finished.
  if ! exists('b:fizzy_candidates') || ! len(b:fizzy_candidates) || ! exists('b:fizzy_previous_position')
    return
  endif

  let line = getline('.')
  let column = col('.')
  let complete_index = 0

  let inserted = line[
        \ max([0, b:fizzy_previous_position - 1]) :
        \ min([column - 2, len(line) - 1])
        \ ]
  for candidate in b:fizzy_candidates
    if inserted == candidate
      let position = getpos('.')
      let before = ''
      if b:fizzy_previous_position > 1
        let before = line[0 : b:fizzy_previous_position - 2]
      endif

      let complete_options = b:fizzy_arguments[complete_index]
      let complete_lines = call(complete_options['fn'], complete_options['arguments'])

      call setline('.', before . line[column : ])
      call setpos('.', [position[0], position[1], len(before) + 1, 0])

      " Let UltiSnips handle all the heavy lifting.
      call UltiSnips#Anon(join(complete_lines, "\n"), '', '', 'i')

      break
    endif
    let complete_index = complete_index + 1
  endfor

  " Reset candidates so we don't complete again unless 'completefunc' is used.
  unlet b:fizzy_candidates
  unlet b:fizzy_arguments
  unlet b:fizzy_previous_position
endfunction " }}}
