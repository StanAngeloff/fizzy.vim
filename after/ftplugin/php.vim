setlocal completefunc=fizzy#Complete

let b:fizzy_complete_patterns = [
      \ { 'title': 'private $\4;',
      \   'patterns': ['\(p\|prv\|priv\|private\)\(\s\+\(\%(\\\|\h\)[0-9A-Za-z_\\]*\)\)\?\s\+\$\(\h\w*\)\;\?'],
      \   'fn': 'fizzy#completions#php#private_property' },
      \
      \ { 'title': 'if (isset ($\1)) { ... }',
      \   'patterns': ['if\s\+isset\(\(\s\+$\h\w*\(\(->\h\w*\)*\)\)\+\)'],
      \   'fn': 'fizzy#completions#php#if_isset' },
      \
      \ { 'title': 'return $this->\1;',
      \   'patterns': ['return\s\+\$this->\(\h\w*\)\s*=\s*new\s\+\(\h[0-9A-Za-z_\\]*\)\(([^)]*)\)\?\;\?'],
      \   'fn': 'fizzy#completions#php#return_initialized_property' },
      \
      \ { 'title': '(isset ($\1\2) ? $\1\2\6 : null)',
      \   'patterns': ['\$\(\h\w*\)\(\(\(->\h\w*\(([^)]*)\)\?\)\)*\)?\(\(\(->\h\w*\(([^)]*)\)\?\)\)*\)\;\?'],
      \   'fn': 'fizzy#completions#php#ternary_isset' }
      \ ]
