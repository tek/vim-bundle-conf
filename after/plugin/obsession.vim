if exists('g:session_dir') && !argc() && !exists('g:maque_remote')
  let s:session_file = join([g:session_dir, 'Session.vim'], '/')
  let cwd = $PWD
  if filereadable(s:session_file)
    execute 'silent! source ' . s:session_file
    silent! redraw!
    normal! zv
    silent! iunmap :
    cd $PWD
  elseif exists('g:project_name')
    silent InitObsession
  endif
endif
