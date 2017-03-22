function! test#scala#android#test_file(file) abort "{{{
  return a:file =~ '.*\<' . g:scala_integration_rex . '/test.*/.*.scala'
endfunction "}}}

function! test#scala#android#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    return s:nearest_test(a:position)
  else
    return []
  endif
endfunction "}}}

let s:runner = 'android.test.InstrumentationTestRunner'

function! test#scala#android#build_args(args) abort "{{{
  let pkg = test#scala#android#package()
  return ['class'] + a:args
endfunction "}}}

function! test#scala#android#executable() abort "{{{
  return tek#bundle#scala#sbt_prefixed('android:test-only')
endfunction "}}}

let s:patterns = {
  \ 'test':      ['\v^\s*def %(setup)\@<!([^_]\w+)'],
  \ 'namespace': ['\v^\s*class (\w+)'],
\}

function! test#scala#android#package() abort "{{{
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
      \ 'namespace': ['\v.*<class (\w+%(Test|Spec)).*'],
      \ 'test': ['.*\v<def (\w+).*'],
\}

function! s:nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let pkg = test#scala#android#package()
  let cls = get(name['namespace'], 0, '')
  let test = get(name['test'], 0, '')
  return empty(cls) || empty(pkg) || empty(test) ? [] :
        \ [pkg . '.' . cls . '#' . test]
endfunction "}}}
