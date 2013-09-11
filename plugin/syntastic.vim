" coding: utf-8

let g:syntastic_stl_format = '[%E{E: #%e}%B{, }%W{W: #%w}]'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_check_on_wq=0
let g:syntastic_aggregate_errors=1

let g:syntastic_haml_checkers = []

map <silent> <f7> :call tek#bundle#syntastic#cycle()<cr>
let g:syntastic_filetype_map = {
  \ 'rspec': 'ruby',
  \ 'gentoo-metadata': 'xml',
  \ }
