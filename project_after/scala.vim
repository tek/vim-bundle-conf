MaqueAddCapturedService 'sbt', {
      \ 'start': 1,
      \ 'create_minimized': 0,
      \ 'compiler': 'sbt_scala',
      \ 'quit_copy_mode': 0,
      \ }

function! s:sbt(name, cmd, do_eval) abort "{{{
  call maque#add_command(a:name, a:cmd, {
        \ 'cmd_type': a:do_eval ? 'eval' : 'shell',
        \ 'pane_name': 'sbt',
        \ 'nested': 1,
        \ 'depend': ['sbt'],
        \ 'compiler': 'sbt_scala',
        \ 'copy_to_main': 1,
        \ }
        \ )
endfunction "}}}

for params in [
      \ ['run', 'g:sbt_run', 1],
      \ ['test', 'g:sbt_test', 1],
      \ ['compile', 'g:sbt_compile', 1],
      \ ['clean', 'clean', 0],
      \ ['reload', 'reload', 0],
      \ ]
  call call('s:sbt', params)
endfor

if exists('g:project_android')
  call s:sbt('integration',  'integration/android:test', 0)
endif

MaqueAddCommand 'g:sbt_command', {
      \ 'name': 'sbt command',
      \ 'pane_name': 'sbt',
      \ 'cmd_type': 'eval',
      \ 'nested': 1,
      \ 'depend': ['sbt'],
      \ 'compiler': 'sbt_scala',
      \ 'quit_copy_mode': 0,
      \ }

function! Sbt_command(cmd) abort "{{{
  let g:sbt_command = a:cmd
  MaqueRunCommand sbt command
endfunction "}}}

command! -nargs=+ Sbt call Sbt_command(<q-args>)
map <leader>j :Sbt<space>

function! Clean_current() abort "{{{
  if exists('g:sbt_prefix')
    call Sbt_command(g:sbt_prefix . '/clean')
  endif
endfunction "}}}

nnoremap <silent> <f5> :MaqueRunCommand run<cr>
nnoremap <silent> <leader><f5> :call Clean_current()<cr>
nnoremap <silent> <f6> :MaqueRunCommand compile<cr>
nnoremap <silent> <leader><f6>
      \ :MaqueRunCommand clean<cr>:MaqueRunCommand compile<cr>
nnoremap <silent> <f7> :MaqueToggleCommand log<cr>
nnoremap <silent> <leader><f7> :call Sbt_command('; reload ; compile')<cr>
nnoremap <silent> <f8> :MaqueTmuxFocus sbt<cr>
nnoremap <silent> <s-f1> :MaqueRunCommand test<cr>
nnoremap <silent> <f11> :MaqueRunCommand reload<cr>

let g:ctrlp_custom_ignore['dir'] .= '|/%(project/target|project/project/target|target|bin|gen)'
let g:maque_tmux_error_pane = 'sbt'
let g:sbt_command = 'compile'

function! s:hook() abort "{{{
  if maque#making('run', 'integration')
    MaqueTmuxClearLog log
  elseif maque#making('compile', 'reload', 'test')
    MaqueTmuxMinimizePane log
  endif
endfunction "}}}

augroup tek_scala
  autocmd!
  autocmd User MaqueTmuxMake call s:hook()
augroup END
