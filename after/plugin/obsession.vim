if exists('g:session_dir') && !argc()
  let s:session_file = join([g:session_dir, 'Session.vim'], '/')
  if filereadable(s:session_file)
    execute 'silent! source' s:session_file
    silent! redraw!
    normal! zv
  endif
endif
