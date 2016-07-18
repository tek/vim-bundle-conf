if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::\w*'

let g:deoplete#omni#input_patterns.scala = [
      \ '[^. *\t]\.\w*',
      \ '[:\[,] ?\w*',
      \ '^import .*'
      \ ] 
