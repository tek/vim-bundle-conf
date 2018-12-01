if exists('g:project_bootstrapped') && g:project_detected
    MyoAddSystemCommand { "ident": "tig", "line": "tig status" }
endif

function! s:tig() abort "{{{
  MyoRun tig
  " MyoTmuxFocus main
  return ''
endfunction "}}}

command! Tig call <sid>tig()

nnoremap <silent> <c-f1> :call <sid>tig()<cr>
nnoremap <silent> <f25> :call <sid>tig()<cr>
