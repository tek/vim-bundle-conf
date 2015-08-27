let g:sbt_layout = exists('$kaon') ? 'bg' : 'make'

MaqueAddCapturedService 'sbt', {
      \ 'start': 1,
      \ 'create_minimized': 1,
      \ 'minimized_size': 25,
      \ 'size': 48,
      \ 'compiler': 'sbt_scala',
      \ 'quit_copy_mode': 0,
      \ 'layout': g:sbt_layout,
      \ }

function! CreateSbtCommand(name, cmd, do_eval) abort "{{{
  call maque#add_command(a:name, a:cmd, {
        \ 'cmd_type': a:do_eval ? 'eval' : 'shell',
        \ 'shell': 'sbt',
        \ }
        \ )
endfunction "}}}

for params in [
      \ ['run', 'g:sbt_run', 1],
      \ ['compile', 'g:sbt_compile', 1],
      \ ['clean', ';clean ;update', 0],
      \ ['reload', 'reload', 0],
      \ ['update', 'update', 0],
      \ ]
  call call('CreateSbtCommand', params)
endfor

MaqueAddCommand 'g:sbt_command', {
      \ 'name': 'sbt command',
      \ 'cmd_type': 'eval',
      \ 'shell': 'sbt',
      \ 'quit_copy_mode': 0,
      \ }

MaqueAddCommand 'g:maqueprg', {
      \ 'name': 'sbt test',
      \ 'cmd_type': 'eval',
      \ 'shell': 'sbt',
      \ 'quit_copy_mode': 0,
      \ }

let g:maque_auto_command = 'sbt test'

command! -nargs=+ Sbt call tek#bundle#scala#sbt(<q-args>)
map <leader>j :Sbt<space>

function! Clean_current() abort "{{{
  let pre = exists('g:sbt_prefix') && len(g:sbt_prefix) ? g:sbt_prefix . '/'
          \ : ''
  call tek#bundle#scala#sbt(';' . pre . 'clean ;' . pre . 'update')
endfunction "}}}

nnoremap <silent> <f5> :MaqueRunCommand run<cr>
nnoremap <silent> <leader><f5> :call Clean_current()<cr>
nnoremap <silent> <f6> :MaqueRunCommand compile<cr>
nnoremap <silent> <leader><f6>
      \ :MaqueRunCommand clean<cr>:MaqueRunCommand compile<cr>
nnoremap <silent> <f7> :MaqueTmuxFocus log<cr>
nnoremap <silent> <s-f7> :MaqueToggleCommand log<cr>
nnoremap <silent> <f8> :MaqueTmuxFocus sbt<cr>:call maque#tmux#command('resize-pane -Z')<cr>
nnoremap <silent> <s-f8> :MaqueToggleCommand sbt<cr>
nnoremap <silent> <f11> :MaqueRunCommand reload<cr>

let g:ctrlp_custom_ignore['dir'] .= '|<%(project/target|project/project/target|target|bin|gen)>'
let g:ctrlp_custom_ignore['file'] .= '|^hs_err'
let g:maque_tmux_error_pane = 'sbt'
let g:sbt_command = 'compile'

function! s:hook() abort "{{{
  if maque#making('run')
    MaqueTmuxClearLog log
  elseif maque#making('compile', 'reload')
    MaqueTmuxMinimizePane log
  endif
endfunction "}}}

augroup tek_scala
  autocmd!
  autocmd User MaqueTmuxMake call s:hook()
augroup END

let s:override = exists("g:override_project_scala")

if !s:override
  call AddScalaProjects('pulsar')
endif

silent call tek#bundle#scala#set_project()
