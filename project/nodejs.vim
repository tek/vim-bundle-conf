set path+=src/node_modules,src/main,src

let g:output_patterns += [
      \ 'console\\.log\\(',
      \ ]

MyoShellCommand test { 'line': 'npm run test:watch' }
nnoremap <silent> <f5> :MyoRun test<cr>

MyoTmuxCreatePane serve { 'parent': 'main', 'max_size': 35, 'position': 0.8, 'weight': 0.1 }
MyoShellCommand serve { 'line': 'npm run dev:watch', 'target': 'serve', 'kill': True }
nnoremap <silent> <f6> :MyoRun serve<cr>

MyoTmuxCreatePane purs { 'parent': 'main', 'max_size': 35, 'position': 0.9, 'weight': 0.1 }
MyoShellCommand purs { 'line': 'npm run purs:dev', 'target': 'purs', 'kill': True }
nnoremap <silent> <f7> :MyoRun purs<cr>

let g:test#runners = {
      \ 'javascript': ['Ava', 'Tape']
      \ }
let test#javascript#runner = 'ava'
