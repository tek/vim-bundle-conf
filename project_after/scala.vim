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

function! _sbt_project_cmd_nohist(name, ...) abort "{{{
  return call('_sbt_project_cmd', [a:name] + a:000 + ['''history'': False'])
endfunction "}}}

let g:scala#sbt_cmdline_index = 0
let g:scala#sbt_cmdline = 'sbt'
let g:scala#sbt_cmdlines = ['sbt', 'sbt -sbt-dir ~/.config/sbt-min', 'sbt -sbt-dir ~/.config/sbt-min-release']

function! s:toggle_sbt_min() abort "{{{
  let g:scala#sbt_cmdline_index = (g:scala#sbt_cmdline_index + 1) % len(g:scala#sbt_cmdlines)
  let g:scala#sbt_cmdline = g:scala#sbt_cmdlines[g:scala#sbt_cmdline_index]
  echo 'cmdline `' . g:scala#sbt_cmdline . '`'
endfunction "}}}

command! -bar -nargs=0 SbtMin call <sid>toggle_sbt_min()
nnoremap <c-f4> :SbtMin<cr>

if g:crm_dev
  let g:myo_test_langs = ['scala']
  MyoCreatePane {
        \ "layout": "make",
        \ "ident": "sbt",
        \ "min_size": 0.5,
        \ "max_size": 35,
        \ "position": 0.8
        \ }
  MyoAddSystemCommand { "ident": "sbt", "line": "sbt", "target": "sbt", "langs": ["scala"] }
  MyoAddShellCommand { "ident": "compile", "line": "compile", "target": "sbt" }
  MyoAddShellCommand { "ident": "release", "line": "release with-defaults", "target": "sbt" }
  nnoremap <silent> <f6> :MyoLine { "shell": "sbt", "line": "compile" }<cr>
  nnoremap <silent> <f9> :MyoTogglePane make<cr>
else
  MyoTmuxCreatePane sbt { 'parent': 'main', 'min_size': 0.5, 'max_size': 35, 'position': 0.8 }
  MyoShell sbt { 'line': 'var:scala#sbt_cmdline', 'target': 'sbt', 'langs': ['sbt'], 'signals': ['kill'],
        \ 'history': False, 'eval': True }
  call _sbt_project_cmd('compile')
  call _sbt_project_cmd('test', 'test')
  call _sbt_project_cmd_nohist('clean', 'clean')
  call _sbt_project_cmd('publishLocal', '+publishLocal')
  MyoShellCommand release { 'line': 'release with-defaults', 'shell': 'sbt', 'langs': ['sbt'] }
  MyoUpdate layout <vim> { 'minimized_size': 85 }

  let g:myo_chainer = 'py:myo_bundle.chain_sbt'

  command! -nargs=+ Sbt MyoRunInShell sbt { 'line': '<args>', 'langs': ['sbt'] }
  command! -nargs=+ SbtNh MyoRunInShell sbt { 'line': '<args>', 'langs': ['sbt'], 'history': False }
  nnoremap <silent> <f6> :MyoRun compile<cr>
  nnoremap <silent> <f5> :MyoRun test<cr>
  nnoremap <silent> <s-f6> :MyoRun clean<cr>
  nnoremap <silent> <f7> :MyoTmuxFocus log<cr>
  nnoremap <silent> <s-f7> :MyoToggleCommand log<cr>
  nnoremap <silent> <f8> :MyoTmuxFocus sbt<cr>
  nnoremap <silent> <s-f8> :MyoToggleCommand sbt<cr>
  nnoremap <silent> <leader><f8> :call SbtScrollToError()<cr>
  nnoremap <silent> <f11> :SbtNh reload<cr>
  nnoremap <silent> <f12> :SbtNh r<cr>
  nnoremap <silent> <c-f2> :MyoRebootCommand sbt<cr>
  nnoremap <silent> <f26> :MyoRebootCommand sbt<cr>
  nnoremap <silent> <c-f3> :MyoRun publishLocal<cr>
  nnoremap <silent> <f27> :MyoRun publishLocal<cr>

  map <leader>j :Sbt<space>
endif

let g:ctrlp_custom_ignore['file'] .= '|^hs_err'
let g:ctrlp_custom_ignore['dir'] .= '|<node_modules>|<stylesheets_gen>|<soapui>|<bower_components>'
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

function! s:splain(...) abort "{{{
  return s:compiler_param('splain', '-P:splain:all:false', 1)
endfunction "}}}

command! Splain call <sid>splain()

highlight clear EnErrorStyle
highlight EnErrorStyle ctermbg=0

let g:output_patterns +=
      \ ['[^.]\\b(pr|p|print(ln)?|dHead|dbg)\\(', '^\ *(hl|nl)$',
      \ '\\.p\\(\\)', '\\.dbg\\b']
let g:output_file_patterns += ['*.scala']
let g:ctags_langs += ['scala']
