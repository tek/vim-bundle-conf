if expand('%') =~ '.*_\(test\|spec\).py'
  compiler spec
  let b:maque_filetype = 'spec'
endif
