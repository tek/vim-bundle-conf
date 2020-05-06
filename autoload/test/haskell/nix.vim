function! test#haskell#nix#test_file(file) abort "{{{
  return g:hs_test_nix && fnamemodify(a:file, ':p') =~ '.*\.hs'
endfunction "}}}

function! s:try_runner(position, meta, patterns, runner) abort "{{{
  let result = test#base#nearest_test(a:position, a:patterns)
  let test = get(result['test'], 0, '')
  return empty(test) ? [] : [a:meta.dir, a:meta.module, test, a:meta.type, a:runner]
endfunction "}}}

function! test#haskell#nix#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    let meta = test#haskell#lib#meta(a:position['file'])
    let h = s:try_runner(a:position, meta, s:hedgehog_patterns, 'hedgehog')
    if empty(h)
      let g = s:try_runner(a:position, meta, s:generic_patterns, 'generic')
      return empty(g) ? 0 : g
    else
      return h
    endif
  else
    return []
  endif
endfunction "}}}

function! test#haskell#nix#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#haskell#nix#executable() abort "{{{
  return g:haskell_nix_test_runner
endfunction "}}}

let s:hedgehog_patterns = {
      \ 'test': ['\v^(\w+) :: (Test|Property)', 'main :: IO ()'],
      \ 'namespace': [],
      \ }

let s:generic_patterns = {
      \ 'test': ['\v^(%(\w|'')+) :: .*'],
      \ 'namespace': [],
      \ }

function! test#haskell#nix#nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let spec = get(name['test'], 0, '')
  return empty(spec) ? [] : [spec]
endfunction "}}}
