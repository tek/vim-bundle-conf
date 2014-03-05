if exists('g:project_name')
  let g:sessions_dir = get(g:, 'sessions_dir', expand('~/usr/var/tmp/vim/session'))
  let s:session_dir = join([g:sessions_dir, g:project_type, g:project_name], '/')
  silent! call mkdir(s:session_dir, 'p')
  let g:session_dir = get(g:, 'session_dir', s:session_dir)

  command! -bar -bang -complete=file -nargs=? InitObsession exe 'Obsession' g:session_dir
endif
