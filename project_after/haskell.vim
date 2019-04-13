if get(g:, 'myo_hs', 0)
  call MyoAddSystemCommand({
        \ 'ident': 'stack-build',
        \ 'lines': ['stack build --fast --pedantic'],
        \ 'target': 'make',
        \ 'lang': 'haskell',
        \ })
else
  function! s:test_project() abort "{{{
    return get(g:, 'htf_project_name', '')
  endfunction "}}}
  MyoCreatePane { "ident": "ghci", "layout": "make", "min_size": 0.5, "max_size": 35, "position": 0.8 }
  MyoAddSystemCommand { "ident": "ghci", "line": "ghci", "target": "ghci", "langs": ["haskell"], "history": false }
  MyoAddSystemCommand { "ident": "stack-build", "line": "stack build --fast --pedantic", "target": "make", "langs": ["haskell"] }
  MyoAddSystemCommand { "ident": "stack-build-lenient", "line": "stack build --fast", "target": "make", "langs": ["haskell"] }
  execute 'MyoAddSystemCommand { "ident": "stack-test", "line": "stack test --fast --pedantic ' . s:test_project() . '", "target": "make", "langs": ["haskell"] }'
endif

nnoremap <silent> <f5> :MyoRun stack-test<cr>
nnoremap <silent> <f6> :MyoRun stack-build<cr>
nnoremap <silent> <s-f6> :MyoRun stack-build-lenient<cr>

let g:ctrlp_custom_ignore['file'] .= '|^codex.tags'
let g:ctrlp_custom_ignore['dir'] .= '|/temp/'
let g:myo_test_langs = ['haskell']
let g:tek_misc#postsave_functions += ['haskell#sort_imports_save']
