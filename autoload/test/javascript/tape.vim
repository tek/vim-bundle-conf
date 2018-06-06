function! test#javascript#tape#test_file(fname) abort "{{{
  return test#util#want('javascript', 'node') && a:fname =~ '\(^\|.*/\)test/.*'
endfunction "}}}

function! test#javascript#tape#build_position(type, position) abort "{{{
  let fname = tek_misc#canonical_path(a:position['file'])
  if a:type == 'nearest'
    return [fname]
  elseif a:type == 'file'
    return [fname]
  else
    return []
  endif
endfunction "}}}

function! test#javascript#tape#build_args(args) abort "{{{
  return [] + a:args
endfunction "}}}

function! test#javascript#tape#executable() abort "{{{
  return 'tape'
endfunction "}}}
