if exists('g:proteome_main_name')
  call tek_bundle_misc#init_session_dir()
endif

if exists('g:session_dir') && !argc()
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
