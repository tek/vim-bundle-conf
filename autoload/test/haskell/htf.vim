function! test#haskell#htf#test_file(file) abort "{{{
  return fnamemodify(a:file, ':p') =~ '\v.*(test|unit).*\.hs'
endfunction "}}}

function! test#haskell#htf#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    let name = get(g:, 'htf_project_name', g:proteome_main_name)
    let f = a:position['file']
    let is_unit = f[:6] == 'test/u/'
    let skip = is_unit ? 'functional' : 'unit'
    let skip_arg = ['--skip', name . '-' . skip, '--skip', name . '-exe']
    return test#haskell#htf#nearest_test(a:position) + skip_arg
  else
    return []
  endif
endfunction "}}}

function! test#haskell#htf#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#haskell#htf#executable() abort "{{{
  let name = get(g:, 'htf_project_name', g:proteome_main_name)
  return 'stack test ' . name . ' --fast --pedantic --ta'
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
