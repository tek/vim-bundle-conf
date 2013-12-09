if expand('%') =~ '.*_test.py'
  compiler spec
  let b:maque_filetype = 'spec'
endif
