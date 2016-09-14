function! test#scala#specs2#test_file(file) abort "{{{
  return a:file =~ '.*test.*/.*.scala'
endfunction "}}}

function! test#scala#specs2#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    return s:nearest_test(a:position)
  else
    return []
  endif
endfunction "}}}

function! test#scala#specs2#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#scala#specs2#executable() abort "{{{
  return tek#bundle#scala#sbt_prefixed('test-only')
endfunction "}}}

let s:patterns = {
  \ 'test':      ['\v^\s*def %(setup)\@<!([^_]\w+)'],
  \ 'namespace': ['\v^\s*class (\w+)'],
\}

function! test#scala#specs2#package() abort "{{{
  let i = 1
  let pkgline = ''
  while getline(i) =~ '^package .*'
    if i != 1
      let pkgline .= '.'
    endif
    let pkgline .= substitute(getline(i), 'package \(.*\)', '\1', '')
    let i += 1
  endwhile
  return pkgline
endfunction "}}}

let s:patterns = {
      \ 'test': ['\v.*<class (\w+%(Test|Spec)).*'],
      \ 'namespace': [],
\}

function! s:nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let pkg = test#scala#specs2#package()
  let cls = get(name['test'], 0, '')
  return empty(cls) || empty(pkg) ? [] : [join([pkg, cls], '.')]
endfunction "}}}
