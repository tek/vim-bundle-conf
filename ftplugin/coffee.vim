if get(g:, 'project_teaspoon') && expand('%') =~ '.*_spec.coffee'
  compiler teaspoon
  let b:maque_filetype = 'teaspoon'
endif

