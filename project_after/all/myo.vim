MyoCreatePane { "ident": "aux", "layout": "make", "min_size": 0.1, "max_size": 0.3, "position": 0.8 }

nnoremap <silent> <c-f2> :MyoTogglePane aux<cr>

MyoAddSystemCommand { "ident": "tig", "line": "tig status", "target": "make", "history": false }

function! s:tig() abort "{{{
  MyoRun tig
  MyoFocus make
  return ''
endfunction "}}}

command! Tig call <sid>tig()

nnoremap <silent> <c-f1> :call <sid>tig()<cr>
nnoremap <silent> <f25> :call <sid>tig()<cr>
