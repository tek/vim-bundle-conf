let g:neocomplete#enable_at_startup = 1
let g:neocomplete#auto_completion_start_length = 0
let g:neocomplete#data_directory = '~/.cache/neocomplete'
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#lock_buffer_name_pattern = '*unite*'
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#enable_auto_close_preview = 0
let g:neocomplete#sources#omni#input_patterns = get(g:, 'neocomplete#sources#omni#input_patterns', {})
let g:neocomplete#sources#omni#input_patterns.python = '[^. \t]\.\w*\|from .* import \w*'
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::\w*'
let g:neocomplete#manual_completion_start_length = 0
inoremap <expr><m-m> neocomplete#start_manual_complete()