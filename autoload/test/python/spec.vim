function! test#python#spec#test_file(file) abort "{{{
  return a:file =~ '.*_spec.py'
endfunction "}}}

function! test#python#spec#build_position(type, position) abort "{{{
  let file = tek_misc#canonical_path(a:position['file'])
  if a:type == 'nearest'
    let test = tek#bundle#python#nearest_test(a:position)
    if empty(test)
      return [file]
    else
      return [file.':'.test]
    endif
  elseif a:type == 'file'
    return [file]
  else
    return []
  endif
endfunction "}}}

function! test#python#spec#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#python#spec#executable() abort "{{{
  return 'spec'
endfunction "}}}
