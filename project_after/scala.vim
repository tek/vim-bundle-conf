let g:sbt_layout = exists('$kaon') ? 'bg' : 'make'
let s:sbt_size = exists('$kaon') ? 20 : 48

function! _sbt_project_cmd(name, ...) abort "{{{
  let line = a:0 ? a:1 : a:name
  let extra = a:0 > 1 ? ', ' . a:2 : ''
  execute "MyoShellCommand " . a:name .
        \ " { 'line': 'py:myo_bundle.SbtProjectCmd'," .
        \ " 'shell': 'sbt', 'langs': ['sbt'], 'eval': True, 'args': ['" .
        \ line . ''']' . extra . ' }'
endfunction "}}}

if g:use_myo
  MyoTmuxCreatePane sbt { 'parent': 'main', 'min_size': 0.5, 'max_size': 35,
        \ 'position': 0.8 }
  MyoShell sbt { 'line': 'sbt', 'target': 'sbt', 'langs': ['sbt'],
        \ 'signals': ['kill'], 'history': False }
  call _sbt_project_cmd('compile')
  call _sbt_project_cmd('test', 'test')
  call _sbt_project_cmd('clean', 'clean', '''history'': False')
  call _sbt_project_cmd('publishLocal')
  MyoShellCommand release { 'line': 'release with-defaults', 'shell': 'sbt',
        \ 'langs': ['sbt'] }
  MyoUpdate layout <vim> { 'minimized_size': 85 }

  let g:myo_chainer = 'py:myo_bundle.chain_sbt'

  command! -nargs=+ Sbt MyoRunInShell sbt { 'line': '<args>', 'langs': ['sbt'] }
  command! -nargs=+ SbtNh MyoRunInShell sbt { 'line': '<args>', 'langs': ['sbt'], 'history': False }
  nnoremap <silent> <f6> :MyoRun compile<cr>
  nnoremap <silent> <f5> :MyoRun test<cr>
  nnoremap <silent> <f6> :MyoRun compile<cr>
  nnoremap <silent> <s-f6> :MyoRun clean<cr>
  nnoremap <silent> <f7> :MyoTmuxFocus log<cr>
  nnoremap <silent> <s-f7> :MyoToggleCommand log<cr>
  nnoremap <silent> <f8> :MyoTmuxFocus sbt<cr>
  nnoremap <silent> <s-f8> :MyoToggleCommand sbt<cr>
  nnoremap <silent> <leader><f8> :call SbtScrollToError()<cr>
  nnoremap <silent> <f11> :SbtNh reload<cr>
  nnoremap <silent> <f12> :SbtNh r<cr>
  nnoremap <silent> <c-f2> :MyoRebootCommand sbt<cr>
  nnoremap <silent> <c-f3> :MyoRun publishLocal<cr>
else
  MaqueAddShell 'sbt', {
        \ 'start': 1,
        \ 'create_minimized': 0,
        \ 'minimized_size': 25,
        \ 'size': 48,
        \ 'compiler': 'sbt_scala',
        \ 'quit_copy_mode': 0,
        \ 'layout': g:sbt_layout,
        \ 'kill_signals': ['KILL'],
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
        \ ['publishLocal', 'publishLocal', 0],
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

  command! -nargs=+ Sbt call tek#bundle#scala#sbt(<q-args>)

  nnoremap <silent> <f5> :MaqueRunCommand run<cr>
  nnoremap <silent> <leader><f5> :MaqueRunCommand clean_current<cr>
  nnoremap <silent> <f6> :MaqueRunCommand compile<cr>
  nnoremap <silent> <leader><f6>
        \ :MaqueRunCommand clean<cr>:MaqueRunCommand compile<cr>
  nnoremap <silent> <f7> :MaqueTmuxFocus log<cr>
  nnoremap <silent> <s-f7> :MaqueToggleCommand log<cr>
  nnoremap <silent> <f8> :MaqueTmuxFocus sbt<cr>
  nnoremap <silent> <s-f8> :MaqueToggleCommand sbt<cr>
  nnoremap <silent> <leader><f8> :call SbtScrollToError()<cr>
  nnoremap <silent> <f11> :MaqueRunCommand reload<cr>
  nnoremap <silent> <s-f11> :MaqueRunCommand reload<cr>
  nnoremap <silent> <c-f11> :MaqueRunCommand reload<cr>:Maque<cr>
  nnoremap <silent> <f12> :Sbt r<cr>
  nnoremap <silent> <c-f2> :MaqueTmuxKillWait sbt<cr>:MaqueRunCommand sbt<cr>
  nnoremap <silent> <c-f3> :MaqueRunCommand publishLocal<cr>
  nmap <silent> <f3> <Plug>(maque-parse):call SbtScrollToError()<cr>zvzz

  let g:maque_auto.shell = 'sbt'
  let g:sbt = maque#command('sbt')
  let g:sbt_pane = maque#tmux#pane('sbt')
  let g:maque_tmux_error_pane = 'sbt'

  autocmd User MaqueInitialized call <sid>setup_maque()

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

  function! SbtScrollToError() abort "{{{
    let pane = maque#pane('sbt')
    call pane.copy_mode_wait()
    call pane.send('?Compiling')
    call pane.send_keys('c-d')
  endfunction "}}}
endif

map <leader>j :Sbt<space>

let g:ctrlp_custom_ignore['dir'] .= '|<%(project/target|project/project/target|target)>'
let g:ctrlp_custom_ignore['file'] .= '|^hs_err'
let g:sbt_command = 'compile'
let s:cpar_used = 0

silent call tek#bundle#scala#set_project()

function! s:compiler_param(name, value, project, ...) abort "{{{
  let flag = 'g:' . a:name . '_state'
  if !exists(flag)
    execute 'let ' . flag . ' = 1'
  endif
  execute 'let state = ' . flag
  if !s:cpar_used
    let s:cpar_used = 1
    SbtNh \ 
  endif
  if a:0 > 1
    let axis = a:2
    let oper = a:1 ? ' +=' : ' -='
  else
    let axis = a:project ? g:sbt_project . '.!' : 'ThisBuild'
    let oper = state ? ' +=' : ' -='
  endif
  execute 'SbtNh set scalacOptions in ' . axis . oper . ' "' . a:value . '"'
  execute 'let ' . flag . ' = !' . flag
endfunction "}}}

function! s:impl(...) abort "{{{
  return s:compiler_param('impl', '-Xlog-implicits', 1)
endfunction "}}}

function! s:splain(...) abort "{{{
  return s:compiler_param('splain', '-P:splain:all:false', 1)
endfunction "}}}

command! -nargs=? ImplOn call <sid>impl(1, <f-args>)
command! -nargs=? ImplOff call <sid>impl(0, <f-args>)
command! Impl call <sid>impl()
command! Splain call <sid>splain()

highlight clear EnErrorStyle
highlight EnErrorStyle ctermbg=0
set omnifunc=
