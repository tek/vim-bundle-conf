function! Test_project() abort "{{{
  return get(g:, 'htf_project_name', '')
endfunction "}}}

function! Compile_project() abort "{{{
  return get(g:, 'haskell_compile_project', Test_project())
endfunction "}}}

if get(g:, 'myo_hs', 0)
  call MyoAddSystemCommand({
        \ 'ident': 'stack-build',
        \ 'lines': ['stack build --fast --pedantic'],
        \ 'target': 'make',
        \ 'lang': 'haskell',
        \ })
else
  MyoCreatePane { "ident": "ghci", "layout": "make", "min_size": 0.5, "max_size": 35, "position": 0.8 }
  MyoAddSystemCommand { "ident": "ghci", "line": "ghci", "target": "ghci", "langs": ["haskell"], "history": false }
  execute 'MyoAddSystemCommand { "ident": "stack-build", "line": "stack build --fast --pedantic ' . Compile_project() . '", "target": "make", "langs": ["haskell"] }'
  execute 'MyoAddSystemCommand { "ident": "stack-build-lenient", "line": "stack build --fast ' . Compile_project() . '", "target": "make", "langs": ["haskell"] }'
  execute 'MyoAddSystemCommand { "ident": "stack-test", "line": "stack test --fast --pedantic ' . Test_project() . '", "target": "make", "langs": ["haskell"] }'
  execute 'MyoAddSystemCommand { "ident": "stack-clean", "line": "stack clean ' . Compile_project() . '", "target": "make" }'
endif

nnoremap <silent> <f5> :MyoRun stack-test<cr>
nnoremap <silent> <f6> :MyoRun stack-build<cr>
nnoremap <silent> <s-f6> :MyoRun stack-build-lenient<cr>
nnoremap <silent> <f7> :MyoRun stack-clean<cr>
nnoremap <silent> <f18> :MyoRun stack-build-lenient<cr>

let g:ctrlp_custom_ignore['file'] .= '|^codex.tags'
let g:ctrlp_custom_ignore['dir'] .= '|/temp/'
let g:myo_test_langs = ['haskell']
let g:tek_misc#postsave_functions += ['haskell#sort_imports_save']
