function! Test_project() abort "{{{
  return get(g:, 'htf_project_name', '')
endfunction "}}}

function! Compile_project() abort "{{{
  return get(g:, 'haskell_compile_project', Test_project())
endfunction "}}}

" let s:sbt_pane =
"       \ {
"       \ 'layout': 'make',
"       \ 'ident': 'ghci',
"       \ 'minSize': 0.5,
"       \ 'maxSize': 35,
"       \ 'position': 8
"       \ }
" let g:myo_ui = {
"       \ "panes": [s:sbt_pane]
"       \ }
" let s:build_cmd = {
"       \ 'ident': 'stack-build',
"       \ 'lines': ['stack build --fast --pedantic ' . Compile_project()],
"       \ 'target': 'make',
"       \ 'lang': 'haskell',
"       \ }
" let s:build_lenient_cmd = {
"       \ 'ident': 'stack-build-lenient',
"       \ 'lines': ['stack build --fast ' . Compile_project()],
"       \ 'target': 'make',
"       \ 'lang': 'haskell',
"       \ }
" let s:test_cmd = {
"       \ 'ident': 'stack-test',
"       \ 'lines': ['stack test --fast --pedantic ' . Test_project()],
"       \ 'target': 'make',
"       \ 'lang': 'haskell',
"       \ }
" let s:test_lenient_cmd = {
"       \ 'ident': 'stack-test-lenient',
"       \ 'lines': ['stack test --fast ' . Test_project()],
"       \ 'target': 'make',
"       \ 'lang': 'haskell',
"       \ }
" let s:clean_cmd = {
"       \ 'ident': 'stack-clean',
"       \ 'lines': ['stack clean ' . Compile_project()],
"       \ 'target': 'make',
"       \ 'lang': 'haskell',
"       \ }
" let s:clean_all_cmd = {
"       \ 'ident': 'stack-clean-all',
"       \ 'lines': ['stack clean'],
"       \ 'target': 'make',
"       \ 'lang': 'haskell',
"       \ }
" let s:system_cmds = [s:build_cmd, s:build_lenient_cmd, s:test_cmd, s:test_lenient_cmd, s:clean_cmd, s:clean_all_cmd]
" let g:myo_commands = { 'system': s:system_cmds, 'shell': [] }

nnoremap <silent> <f5> :MyoRun stack-test<cr>
nnoremap <silent> <s-f5> :MyoRun stack-test-lenient<cr>
nnoremap <silent> <f17> :MyoRun stack-test-lenient<cr>
nnoremap <silent> <f6> :MyoRun stack-build<cr>
nnoremap <silent> <s-f6> :MyoRun stack-build-lenient<cr>
nnoremap <silent> <f18> :MyoRun stack-build-lenient<cr>
nnoremap <silent> <f7> :MyoRun stack-clean<cr>
nnoremap <silent> <s-f7> :MyoRun stack-clean-all<cr>
nnoremap <silent> <f19> :MyoRun stack-clean-all<cr>

let g:ctrlp_custom_ignore['file'] .= '|codex\.tags|.*\.cabal'
let g:ctrlp_custom_ignore['dir'] .= '|/temp/'
" let g:myo_test_lang = 'haskell'
let g:tek_misc#postsave_functions += ['haskell#sort_imports_save']
