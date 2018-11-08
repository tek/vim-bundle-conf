set path+=src/node_modules,src/main,src,src/main/lib

let g:output_patterns += [
      \ 'console\\.log\\(',
      \ ]

if g:crm_dev
  MyoAddShellCommand { "ident": "test", "line": "npm run test:watch", "target": "make" }
  nnoremap <silent> <f5> :MyoRun test<cr>
  MyoCreatePane { "ident": "serve", "layout": "make", "max_size": 35, "position": 0.8, "weight": 0.1 }
  MyoAddShellCommand { "ident": "serve", "line": "npm run dev:watch", "target": "serve" }
  nnoremap <silent> <f6> :MyoRun serve<cr>
  MyoCreatePane { "ident": "purs", "layout": "make", "max_size": 35, "position": 0.9, "weight": 0.1 }
  MyoAddShellCommand { "ident": "purs", "line": "npm run purs:dev", "target": "purs" }
  nnoremap <silent> <f7> :MyoRun purs<cr>
else
  MyoShellCommand test { 'line': 'npm run test:watch' }
  nnoremap <silent> <f5> :MyoRun test<cr>
  MyoTmuxCreatePane serve { 'parent': 'main', 'max_size': 35, 'position': 0.8, 'weight': 0.1 }
  MyoShellCommand serve { 'line': 'npm run dev:watch', 'target': 'serve', 'kill': True }
  nnoremap <silent> <f6> :MyoRun serve<cr>
  MyoTmuxCreatePane purs { 'parent': 'main', 'max_size': 35, 'position': 0.9, 'weight': 0.1 }
  MyoShellCommand purs { 'line': 'npm run purs:dev', 'target': 'purs', 'kill': True }
  nnoremap <silent> <f7> :MyoRun purs<cr>
endif

let g:test#runners = {
      \ 'javascript': ['Ava', 'Tape']
      \ }
let test#javascript#runner = 'ava'
