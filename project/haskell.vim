let g:neomake_haskell_enabled_makers = ['hdevtools']
let g:proteome_tags_command = 'codex'
let g:proteome_tags_args = 'update'

let g:myo_test_lang = 'haskell'
let g:test#runners = { 'haskell': ['htf', 'tasty', 'hedgehog'] }
let g:test#enabled_runners = ['haskell#htf', 'haskell#tasty', 'haskell#hedgehog']
let g:htf = v:true
let g:tasty = v:false
let g:hedgehog = v:false

let g:output_patterns += ['^ .*\bdbg[sm]?\b', '^ .*\bunsafeLog']
let g:output_file_patterns += ['\.hs']

let g:haskell_packages =
      \ isdirectory('modules') ?
      \ 'modules/*/' :
      \ isdirectory('packages') ?
      \ 'packages/*/' :
      \ '*/'

function! s:ispackage(path) abort "{{{
  return !empty(glob(a:path . '/*.cabal')) || filereadable(a:path . '/package.yaml')
endfunction "}}}

function! s:packages() abort "{{{
  return ['.'] + filter(glob(g:haskell_packages, 0, 1), { i, n -> s:ispackage(n) })
endfunction "}}}

function! s:subdir(name) abort "{{{
  return filter(map(s:packages(), { i, p -> p . '/' . a:name }), { i, n -> isdirectory(n) })
endfunction "}}}

function! s:subdirs(names) abort "{{{
  return list#concat(map(a:names, { i, n -> s:subdir(n) }))
endfunction "}}}

function! s:test_dirs() abort "{{{
  return s:subdirs(['test', 'integration'])
endfunction "}}}

function! s:lib_dirs() abort "{{{
  return s:subdirs(['src', 'lib', 'src-bin', 'app'])
endfunction "}}}

function! s:module_dirs() abort "{{{
  let dirs = s:lib_dirs()
  return map(dirs, { i, a -> a[:-5] })
endfunction "}}}

function! s:base_dirs() abort "{{{
  return s:test_dirs() + s:lib_dirs()
endfunction "}}}

let &path .= ',' . join(s:base_dirs(), ',')
let &path .= ',' . join(s:module_dirs(), ',')

function! HaskellFiles() abort "{{{
  execute 'ProFiles ' . join(s:base_dirs(), ' ')
endfunction "}}}

function! GrepImport(query) abort "{{{
  execute 'ProGrep ^import \S+ .*' . a:query
endfunction "}}}

function! GrepFuncDef(query) abort "{{{
  execute 'ProGrep ^\s*' . a:query . '( ::|$)'
endfunction "}}}

nnoremap <silent> <leader>e <cmd>call HaskellFiles()<cr>
nnoremap <silent> <localleader>e :ProFiles<cr>
nnoremap <silent> gai <cmd>call GrepImport('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gai "ay<cmd>call GrepImport(@a)<cr>
nnoremap <silent> gaf <cmd>call GrepFuncDef('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gaf "ay<cmd>call GrepFuncDef(@a)<cr>

let g:haskell_sort_imports = match(getcwd(), 'code/tek/haskell') != -1
