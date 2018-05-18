function! test#scala#specs2#test_file(file) abort "{{{
  return fnamemodify(a:file, ':p') =~ '.*\(test\|it/\).*\.scala'
endfunction "}}}

function! test#scala#specs2#build_position(type, position) abort "{{{
  if a:type == 'nearest'
    return test#scala#specs2#nearest_test(a:position)
  else
    return []
  endif
endfunction "}}}

function! test#scala#specs2#build_args(args) abort "{{{
  return a:args
endfunction "}}}

function! test#scala#specs2#executable() abort "{{{
  let cmd = 'testOnly'
  if fnamemodify(expand('%'), ':p') =~ '.*/it/.*\.scala'
    let cmd = 'it:' . cmd
  endif
  return tek#bundle#scala#sbt_prefixed(cmd)
endfunction "}}}

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
      \ 'test': ['\v.*<%(class|object) (\w+%(Test|Spec)).*'],
      \ 'namespace': [],
\}

function! test#scala#specs2#nearest_test(position) abort "{{{
  let name = test#base#nearest_test(a:position, s:patterns)
  let pkg = test#scala#specs2#package()
  let cls = get(name['test'], 0, '')
  let target = empty(pkg) ? cls : join([pkg, cls], '.')
  return empty(cls) ? [] : [target]
endfunction "}}}
