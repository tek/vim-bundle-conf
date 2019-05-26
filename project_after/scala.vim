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

let g:myo_test_langs = ['scala']
let g:myo_test_lang = 'scala'

if get(g:, 'myo_hs', 0)
  let s:sbt_pane =
        \ {
        \ 'layout': 'make',
        \ 'ident': 'sbt',
        \ 'minSize': 0.5,
        \ 'maxSize': 35,
        \ 'position': 8
        \ }
  let g:myo_ui = {
        \ "panes": [s:sbt_pane]
        \ }
  let s:sbt_cmd = {
        \ 'ident': 'sbt',
        \ 'lines': ['sbt'],
        \ 'target': 'sbt',
        \ 'lang': 'scala',
        \ }
  let s:compile_cmd = {
        \ 'ident': 'compile',
        \ 'lines': ['test:compile'],
        \ 'target': 'sbt',
        \ 'lang': 'scala',
        \ }
  let g:myo_commands = { 'system': [s:sbt_cmd], 'shell': [s:compile_cmd] }
  nnoremap <silent> <f6> :MyoRun compile<cr>
else
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
  command! -nargs=+ Sbt MyoLine { "ident": "<args>", "shell": "sbt", "line": "<args>" }
  command! -nargs=+ SbtNoHistory MyoLine { "shell": "sbt", "line": "<args>", "history": false }
  command! -nargs=+ SbtPrefixed call MyoLine('{ "shell": "sbt", "line": " ' . tek#bundle#scala#sbt_prefixed(<q-args>) . '" }')
  nnoremap <silent> <f5> :SbtPrefixed test<cr>
  nnoremap <silent> <f6> :SbtPrefixed test:compile<cr>
  nnoremap <silent> <s-f6> :SbtNoHistory clean<cr>
  nnoremap <silent> <f11> :SbtNoHistory reload<cr>
  nnoremap <silent> <f12> :SbtNoHistory r<cr>
  nnoremap <silent> <c-f2> :MyoReboot sbt<cr>
endif

let g:ctrlp_custom_ignore['file'] .= '|^hs_err'
let g:ctrlp_custom_ignore['dir'] .= '|<node_modules>|<stylesheets_gen>|<soapui>|<bower_components>|<fonts>|<vendor>'
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

let g:output_patterns += ['^\s*println\(']
let g:output_file_patterns += ['\.scala']
let g:ctags_langs += ['scala']
