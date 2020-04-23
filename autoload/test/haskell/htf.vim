function! test#haskell#htf#test_file(file) abort "{{{
  return g:htf && fnamemodify(a:file, ':p') =~ '\v.*(test|unit|integration).*\.hs'
endfunction "}}}

function! test#haskell#htf#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    let project_map = get(g:, 'haskell_project_map', {})
    let name = get(g:, 'htf_project_name', g:proteome_main_name)
    let meta = matchlist(a:position['file'], '\vmodules/\zs%(bodhi-)?[^/]+\ze/(test|unit|integration)')
    let module = get(meta, 0, '')
    let type = get(meta, 1, 'test')
    let test_skip = type == 'integration' ? 'unit' : 'integration'
    let real_module = get(project_map, module, module)
    let suite = empty(real_module) ? name : real_module
    let general = [suite, '--fast', '--skip', name . '-exe', '--skip', real_module . '-' . test_skip, '--ta']
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
