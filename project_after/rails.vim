let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_include_object = 1
let g:rubycomplete_include_objectspace = 1
let g:rubycomplete_load_gemfile = 0
let g:rubycomplete_load_rails = 1
let g:rubycomplete_use_bundler = 1

let g:pry_command = 'rails console'

function! Reset_log() abort "{{{
  MaqueTmuxResetCapture log
endfunction "}}}

let g:tek_misc#postsave_functions += ['Reset_log']
