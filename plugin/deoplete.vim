let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 0
let g:deoplete#data_directory = '~/.cache/deoplete'
let g:deoplete#enable_auto_delimiter = 1
let g:deoplete#lock_buffer_name_pattern = '*unite*\|Command Line'
let g:deoplete#force_overwrite_completefunc = 1
let g:deoplete#enable_auto_close_preview = 0
let g:deoplete#force_omni_input_patterns = get(g:, 'deoplete#force_omni_input_patterns', {})
let g:deoplete#force_omni_input_patterns.python = '[^. \t]\.\w*\|from .* import \w*'
let g:deoplete#force_omni_input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::\w*'
" let g:deoplete#force_omni_input_patterns.scala = '[^. \t]\.\w*\|import \w*'
let g:deoplete#manual_completion_start_length = 0

inoremap <expr> <m-m> deoplete#start_manual_complete()
