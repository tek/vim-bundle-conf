function! test#haskell#tasty#test_file(file) abort "{{{
  return !g:htf && fnamemodify(a:file, ':p') =~ '\v.*(test|unit).*\.hs'
endfunction "}}}

function! test#haskell#tasty#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    let name = get(g:, 'htf_project_name', g:proteome_main_name)
    let module = matchstr(a:position['file'], '\vmodules/\zs[^/]+\ze/test')
    let general = [empty(module) ? name : module, '--fast', '--skip', name . '-exe', '--ta']
    let test = test#haskell#tasty#nearest_test(a:position)
    return empty(test) ? [] : general + test
  else
    return []
  endif
endfunction "}}}

function! test#haskell#tasty#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#haskell#tasty#executable() abort "{{{
  return 'stack test'
endfunction "}}}

let s:patterns = {
      \ 'test': ['\v.*testCase "([^"]+)"'],
      \ 'namespace': [],
      \ }

function! test#haskell#tasty#nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let test = get(name['test'], 0, '')
  return empty(test) ? [] : ['''-p "\$NF == \\"' . test . '\\""''']
endfunction "}}}
