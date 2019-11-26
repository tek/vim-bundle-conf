function! test#haskell#htf#test_file(file) abort "{{{
  return g:htf && fnamemodify(a:file, ':p') =~ '\v.*(test|unit).*\.hs'
endfunction "}}}

function! test#haskell#htf#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    let name = get(g:, 'htf_project_name', g:proteome_main_name)
    echom a:position['file']
    let module = matchstr(a:position['file'], '\vmodules/\zs[^/]+\ze/test')
    let general = [empty(module) ? name : module, '--fast', '--skip', name . '-exe', '--ta']
    let test = test#haskell#htf#nearest_test(a:position)
    return empty(test) ? [] : general + test
  else
    return []
  endif
endfunction "}}}

function! test#haskell#htf#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#haskell#htf#executable() abort "{{{
  return 'stack test'
endfunction "}}}

let s:patterns = {
      \ 'test': ['\vtest_(\w+)'],
      \ 'namespace': [],
      \ }

function! test#haskell#htf#nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let spec = get(name['test'], 0, '')
  return empty(spec) ? [] : [spec]
endfunction "}}}
