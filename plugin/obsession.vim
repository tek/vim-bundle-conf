command! -bar -bang -complete=file -nargs=? InitObsession exe 'Obsession' g:session_dir
command! -bar KillSession call tek_bundle_misc#kill_session()
