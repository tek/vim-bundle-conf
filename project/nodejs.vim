set path+=src/node_modules,src/main,src,src/main/lib

let g:output_patterns += [
      \ 'console\\.log\\(',
      \ ]

MyoAddShellCommand { "ident": "test", "line": "npm run test:watch", "target": "make" }
nnoremap <silent> <f5> :MyoRun test<cr>
MyoCreatePane { "ident": "serve", "layout": "make", "max_size": 35, "position": 0.8, "weight": 0.1 }
MyoAddShellCommand { "ident": "dev", "line": "npm run dev:watch", "target": "serve" }
MyoAddShellCommand { "ident": "start", "line": "npm run start:watch", "target": "serve" }
nnoremap <silent> <f6> :MyoRun serve<cr>
MyoCreatePane { "ident": "purs", "layout": "make", "max_size": 35, "position": 0.9, "weight": 0.1 }
MyoAddShellCommand { "ident": "purs", "line": "npm run purs:dev", "target": "purs" }
nnoremap <silent> <f7> :MyoRun purs<cr>

let g:test#runners = { 'javascript': ['ava', 'tape'] }
let g:test#enabled_runners = ['javascript#ava', 'javascript#tape']
let test#javascript#runner = 'ava'
