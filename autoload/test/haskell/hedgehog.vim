function! test#haskell#hedgehog#test_file(file) abort "{{{
  return g:hedgehog && fnamemodify(a:file, ':p') =~ '\v.*(test|unit|integration).*\.hs'
endfunction "}}}

function! test#haskell#hedgehog#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    let meta = test#haskell#lib#meta(a:position['file'])
    let test = test#haskell#hedgehog#nearest_test(a:position)
    return empty(test) ? [] : [meta.dir, meta.module] + test
  else
    return []
  endif
endfunction "}}}

function! test#haskell#hedgehog#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#haskell#hedgehog#executable() abort "{{{
  return g:hedgehog_runner
endfunction "}}}

let s:patterns = {
      \ 'test': ['\v^(\w+) :: (Test|Property)'],
      \ 'namespace': [],
      \ }

function! test#haskell#hedgehog#nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let spec = get(name['test'], 0, '')
  return empty(spec) ? [] : [spec]
endfunction "}}}
