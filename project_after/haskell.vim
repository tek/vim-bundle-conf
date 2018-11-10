MyoCreatePane { "ident": "ghci", "layout": "make", "min_size": 0.5, "max_size": 35, "position": 0.8 }
MyoAddSystemCommand { "ident": "ghci", "line": "ghci", "target": "ghci", "langs": ["haskell"], "history": false }
MyoAddSystemCommand { "ident": "stack-build", "line": "stack build --fast --pedantic", "target": "make" }

nnoremap <f6> :MyoRun stack-build<cr>
