if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.python = '[^. \t]\.\w*\|from .* import \w*'
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::\w*'
" let g:neocomplete#sources#omni#input_patterns.scala = '[^. \t]\.\w*\|import \w*'
