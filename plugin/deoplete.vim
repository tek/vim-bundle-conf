let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#auto_completion_start_length = 0
let deoplete#auto_completion_start_length = 0
let deoplete#auto_complete_start_length = 0
let g:deoplete#data_directory = '~/.cache/deoplete'
let g:deoplete#enable_auto_delimiter = 1
let g:deoplete#enable_auto_pairs = 1
let g:deoplete#lock_buffer_name_pattern = '*unite*\|Command Line'
let g:deoplete#force_overwrite_completefunc = 1
let g:deoplete#enable_auto_close_preview = 0
let g:deoplete#manual_completion_start_length = 0
let g:deoplete#enable_refresh_always = 1
let g:deoplete#auto_complete_delay = 50

if !exists('g:deoplete#ignore_sources')
  let g:deoplete#ignore_sources = {}
endif
let g:deoplete#ignore_sources._ = ['ultisnips']

autocmd BufEnter * let b:deoplete_detected_foldmethod = 1

let g:deoplete_logdir = $HOME . '/usr/var/log/deoplete'
let g:deoplete_logfile = g:deoplete_logdir . '/log_' . getpid()
" let g:deoplete#sources#jedi#debug_server = 1

if !isdirectory(g:deoplete_logdir)
  try
    execute 'silent! !mkdir -p ' . g:deoplete_logdir
  catch
  endtry
endif

function! _deoplete_log(level) abort "{{{
  call deoplete#enable_logging(a:level, g:deoplete_logfile)
endfunction "}}}

function! DeopleteDebug() abort "{{{
  call _deoplete_log('DEBUG')
endfunction "}}}
