MyoCreatePane { "ident": "ghci", "layout": "make", "min_size": 0.5, "max_size": 35, "position": 0.8 }
MyoAddSystemCommand { "ident": "ghci", "line": "ghci", "target": "ghci", "langs": ["haskell"], "history": false }
MyoAddSystemCommand { "ident": "stack-build", "line": "stack build --fast --pedantic", "target": "make", "langs": ["haskell"] }
MyoAddSystemCommand { "ident": "stack-test", "line": "stack test --fast --pedantic", "target": "make", "langs": ["haskell"] }
MyoAddSystemCommand { "ident": "stack-install", "line": "stack install", "target": "make", "langs": ["haskell"] }

nnoremap <f5> :MyoRun stack-test<cr>
nnoremap <f6> :MyoRun stack-build<cr>
nnoremap <f7> :MyoRun stack-install<cr>

let g:ctrlp_custom_ignore['file'] .= '|^codex.tags'
let g:ctrlp_custom_ignore['dir'] .= '|/temp/'
let g:myo_test_langs = ['haskell']

let s:source = {
      \ 'word_pattern': '[\w.]*',
      \ 'complete_pattern': [] ,
      \ }
call ncm2#override_source('LanguageClient_haskell', { s -> extend(s, s:source) })
