" coding: utf-8

let g:syntastic_stl_format = '[%E{E: #%e}%B{, }%W{W: #%w}]'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_check_on_wq=0
let g:syntastic_aggregate_errors=0
" let g:loaded_syntastic_python_pylint_checker = 1
let g:syntastic_always_populate_loc_list = 1

let g:syntastic_haml_checkers = []
let g:syntastic_python_checkers = ['flake8']

map <silent> <f7> :call tek#bundle#syntastic#cycle()<cr>
let g:syntastic_filetype_map = {
  \ 'rspec': 'ruby',
  \ 'gentoo-metadata': 'xml',
  \ }
