if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.ruby = '[^. *]\.\w*\|\w*::\w*'
let g:deoplete#omni#input_patterns.python = '[^. ]\.\w*\|import \w*\|from \w*'

let g:deoplete#omni#input_patterns.scala = [
      \ '[^. *\t]\.\w*',
      \ '[:\[,] ?\w*',
      \ '^import .*'
      \ ]

call deoplete#custom#set('_', 'sorters', ['sorter_word'])
