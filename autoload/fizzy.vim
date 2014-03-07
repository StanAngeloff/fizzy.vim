if exists('g:autoloaded_fizzy') " {{{
  finish
endif
let g:autoloaded_fizzy = 1 " }}}

function! fizzy#Complete(findstart, base) " {{{
  if a:findstart
    let [word, start_column, end_column] = fizzy#completions#get_word()
    if len(word)
      return start_column
    endif
    return col('.')
  endif

  let b:fizzy_previous_position = col('.')
  let b:fizzy_candidates = []
  let b:fizzy_arguments = []

  let complete_patterns = fizzy#completions#get_patterns()

  for complete_options in complete_patterns
    for pattern in complete_options['patterns']
      let pattern_matches = matchlist(a:base, pattern)
      if len(pattern_matches)
        call add(b:fizzy_candidates, substitute(complete_options['title'], '\\\([0-9]\)\+', '\=pattern_matches[submatch(1)]', 'g'))
        call add(b:fizzy_arguments, { 'fn': complete_options['fn'], 'arguments': pattern_matches[1 : ] })
      endif
    endfor
  endfor

  return b:fizzy_candidates
endfunction " }}}
