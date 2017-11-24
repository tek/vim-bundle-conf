function! test#haskell#htf#test_file(file) abort "{{{
  return fnamemodify(a:file, ':p') =~ '\v.*(test|unit).*\.hs'
endfunction "}}}

function! test#haskell#htf#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    return test#haskell#htf#nearest_test(a:position)
  else
    return []
  endif
endfunction "}}}

function! test#haskell#htf#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#haskell#htf#executable() abort "{{{
  return 'stack test ' . g:proteome_main_name . ' --fast --pedantic --silent --ta'
endfunction "}}}

let s:patterns = {
      \ 'test': ['\vtest_(\w+)'],
      \ 'namespace': [],
\}

function! test#haskell#htf#nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let spec = get(name['test'], 0, '')
  return empty(spec) ? [] : [spec]
endfunction "}}}
