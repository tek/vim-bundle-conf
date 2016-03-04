let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#auto_completion_start_length = 0
let g:deoplete#data_directory = '~/.cache/deoplete'
let g:deoplete#enable_auto_delimiter = 1
let g:deoplete#enable_auto_pairs = 1
let g:deoplete#lock_buffer_name_pattern = '*unite*\|Command Line'
let g:deoplete#force_overwrite_completefunc = 1
let g:deoplete#enable_auto_close_preview = 0
let g:deoplete#manual_completion_start_length = 0
if !exists('g:deoplete#sources')
  let g:deoplete#sources = {}
endif
let g:deoplete#sources._ =
      \ ['buffer', 'member', 'tag', 'omni']
