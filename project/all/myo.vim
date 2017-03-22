if exists('g:project_bootstrapped') && g:project_detected
  MyoShellCommand tig { 'line': 'tig status', 'focus': 1, 'history': False }
endif

function! s:tig() abort "{{{
  MyoRun tig
  " MyoTmuxFocus main
  return ''
endfunction "}}}

command! Tig call <sid>tig()

nnoremap <silent> <c-f1> :call <sid>tig()<cr>
nnoremap <silent> <f25> :call <sid>tig()<cr>

MyoUpdate pane make { 'kill': 'true' }
