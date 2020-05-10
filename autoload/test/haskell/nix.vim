function! test#haskell#nix#test_file(file) abort "{{{
  return g:hs_test_nix && fnamemodify(a:file, ':p') =~ '.*\.hs'
endfunction "}}}

function! test#haskell#nix#try_runner(position, meta, pattern, runner) abort "{{{
  let patterns = {
      \ 'test': [a:pattern],
      \ 'namespace': [],
      \ }
  let result = test#base#nearest_test(a:position, patterns)
  let test = get(result['test'], 0, '')
  return empty(test) ? [] : [a:meta.dir, a:meta.module, test, a:meta.type, a:runner]
endfunction "}}}

let s:hedgehog_property = '\v^(\k+) :: Property$'
let s:hedgehog_unit = '\v^(\k+) :: %(UnitTest|TestT IO \(\))$'
let s:generic = '\v^(\k+) :: .*'

let s:runners = [
      \ ['hedgehog-property', s:hedgehog_property],
      \ ['hedgehog-unit', s:hedgehog_unit],
      \ ['generic', s:generic],
      \ ]

function! test#haskell#nix#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    let meta = test#haskell#lib#meta(a:position['file'])
    for [runner, pattern] in s:runners
      let result = test#haskell#nix#try_runner(a:position, meta, pattern, runner)
      if !empty(result)
        return result
      endif
    endfor
    return 0
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
