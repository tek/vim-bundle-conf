function! test#javascript#ava#test_file(fname) abort "{{{
  return test#util#want('javascript', 'node') && a:fname =~ '\(^\|.*/\)test/.*'
endfunction "}}}

function! test#javascript#ava#build_position(type, position) abort "{{{
  let fname = tek_misc#canonical_path(a:position['file'])
  if a:type == 'nearest'
    return [fname]
  elseif a:type == 'file'
    return [fname]
  else
    return []
  endif
endfunction "}}}

function! test#javascript#ava#build_args(args) abort "{{{
  return ['-v', '-c=20', '--fail-fast', '--timeout=3s'] + a:args
endfunction "}}}

function! test#javascript#ava#executable() abort "{{{
  return 'ava'
endfunction "}}}
