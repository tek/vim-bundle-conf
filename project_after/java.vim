let g:syntastic_java_javac_classpath = $CLASSPATH

if exists('g:project_android') && !exists('g:project_scala')
  MaqueAddCommand 'rake install start', {
        \ 'name': 'install',
        \ 'copy_to_main': 1,
        \ 'compiler': 'ant_javac',
        \ }

  nnoremap <silent> <f5> :MaqueRunCommand install<cr>
  nnoremap <silent> <f7> :MaqueToggleCommand log<cr>
endif
