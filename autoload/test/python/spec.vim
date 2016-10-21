function! test#python#spec#test_file(file) abort "{{{
  return a:file =~ '.*_spec.py'
endfunction "}}}

function! test#python#spec#build_position(type, position) abort "{{{
  let file = tek_misc#canonical_path(a:position['file'])
  if a:type == 'nearest'
    let test = s:nearest_test(a:position)
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

let s:patterns = {
  \ 'test':      ['\v^\s*def %(setup|_)@<!(\w+)\(self>'],
  \ 'namespace': ['\v^\s*class (\w+)'],
\}

function! s:nearest_test(position) abort
  let data = test#base#nearest_test(a:position, s:patterns)
  if empty(data['namespace']) || empty(data['test'])
    return ''
  else
    return join([data['namespace'][0], data['test'][0]], '.')
  endif
endfunction
