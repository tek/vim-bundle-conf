if expand('%:p') =~ '/t/[^/]\+.vim$'
  compiler rake
  let g:maque_args_rake = 'test'
endif
