let g:sbt_layout = exists('$kaon') ? 'bg' : 'make'

MaqueAddShell 'sbt', {
      \ 'start': 1,
      \ 'create_minimized': 1,
      \ 'minimized_size': 25,
      \ 'size': 48,
      \ 'compiler': 'sbt_scala',
      \ 'quit_copy_mode': 0,
      \ 'layout': g:sbt_layout,
      \ }

function! CreateSbtCommand(name, cmd, do_eval) abort "{{{
  call maque#create_command(a:name, a:cmd, {
        \ 'cmd_type': a:do_eval ? 'eval' : 'shell',
        \ 'shell': 'sbt',
        \ }
        \ )
endfunction "}}}

for params in [
      \ ['run', 'g:sbt_run', 1],
      \ ['compile', 'g:sbt_compile', 1],
      \ ['clean', 'clean', 0],
      \ ['clean_current', 'tek#bundle#scala#sbt_prefixed("clean")', 1],
      \ ['reload', 'reload', 0],
      \ ['update', 'update', 0],
      \ ['release', 'release with-defaults', 0],
      \ ]
  call call('CreateSbtCommand', params)
endfor

MaqueAddCommand 'g:sbt_command', {
      \ 'name': 'sbt command',
      \ 'cmd_type': 'eval',
      \ 'shell': 'sbt',
      \ 'quit_copy_mode': 0,
      \ 'remember': 1,
      \ }

MaqueAddCommand 'g:maqueprg', {
      \ 'name': 'sbt test',
      \ 'cmd_type': 'eval',
      \ 'shell': 'sbt',
      \ 'quit_copy_mode': 0,
      \ }

function! s:setup_maque() abort "{{{
  let g:maque_auto.shell = 'sbt'
endfunction "}}}

autocmd User MaqueInitialized call <sid>setup_maque()

command! -nargs=+ Sbt call tek#bundle#scala#sbt(<q-args>)
map <leader>j :Sbt<space>

nnoremap <silent> <f5> :MaqueRunCommand run<cr>
nnoremap <silent> <leader><f5> :MaqueRunCommand clean_current<cr>
nnoremap <silent> <f6> :MaqueRunCommand compile<cr>
nnoremap <silent> <leader><f6>
      \ :MaqueRunCommand clean<cr>:MaqueRunCommand compile<cr>
nnoremap <silent> <f7> :MaqueTmuxFocus log<cr>
nnoremap <silent> <s-f7> :MaqueToggleCommand log<cr>
nnoremap <silent> <f8> :MaqueTmuxFocus sbt<cr>
nnoremap <silent> <s-f8> :MaqueToggleCommand sbt<cr>
nnoremap <silent> <f11> :MaqueRunCommand reload<cr>
nnoremap <silent> <s-f11> :MaqueRunCommand reload<cr>
nnoremap <silent> <c-f2> :MaqueTmuxKill sbt<cr>:MaqueRunCommand sbt<cr>

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
