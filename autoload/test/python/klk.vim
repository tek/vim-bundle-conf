function! test#python#klk#test_file(fname) abort "{{{
  return a:fname =~ '.*_spec.py'
endfunction "}}}

function! test#python#klk#build_position(type, position) abort "{{{
  let fname = tek_misc#canonical_path(a:position['file'])
  if a:type == 'nearest'
    let test = tek#bundle#python#nearest_test(a:position)
    if empty(test)
      return [fname]
    else
      return [fname . ':' . test]
    endif
  elseif a:type == 'file'
    return [fname]
  else
    return []
  endif
endfunction "}}}

function! test#python#klk#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#python#klk#executable() abort "{{{
  return 'klk'
endfunction "}}}
