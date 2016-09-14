if g:use_myo
  if exists('g:project_bootstrapped') && g:project_detected
    MyoShellCommand tig { 'line': 'tig status', 'focus': 1 }
  endif

  function! s:tig() abort "{{{
    " MyoTmuxZoom main
    MyoRun tig
    return ''
  endfunction "}}}

  command! Tig call <sid>tig()

  nnoremap <expr> <silent> <c-f1> <sid>tig()
endif
