" coding: utf-8

let g:syntastic_stl_format = '[%E{E: #%e}%B{, }%W{W: #%w}]'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
map <silent> <leader>q :Error<cr><c-w><c-w>
