let g:neomake_haskell_enabled_makers = ['hdevtools']
let g:proteome_tags_command = 'codex'
let g:proteome_tags_args = 'update'

let g:myo_test_lang = 'haskell'
let g:test#runners = { 'haskell': ['htf', 'nix'] }
let g:test#enabled_runners = ['haskell#htf', 'haskell#nix']
let g:htf = v:false
let g:hs_test_nix = v:true

let g:output_patterns += ['^ .*\bdbg[sm]?\b', '^ .*\bunsafeLog', '^ .*\btr(s''?)?\b ']
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
let &path .= ',' . 'ops/hpack'

function! HaskellFiles() abort "{{{
  execute 'ProFiles ' . join(s:base_dirs(), ' ')
endfunction "}}}

function! GrepImport(query) abort "{{{
  execute 'ProGrep ^import \S+ .*' . a:query
endfunction "}}}

function! GrepImportCtor(query) abort "{{{
  execute 'ProGrep ^import \S+ .*\b' . a:query . '\(' . a:query . '\)'
endfunction "}}}

function! GrepImportQualified(query) abort "{{{
  execute 'ProGrep ^import \S+ .* as ' . a:query
endfunction "}}}

function! GrepFuncDef(query) abort "{{{
  execute 'ProGrep ^\s*' . a:query . '( ::|$)'
endfunction "}}}

nnoremap <silent> <leader>e <cmd>call HaskellFiles()<cr>
nnoremap <silent> <localleader>e :ProFiles<cr>
nnoremap <silent> gai <cmd>call GrepImport('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gai "ay<cmd>call GrepImport(@a)<cr>
nnoremap <silent> gac <cmd>call GrepImportCtor('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gac "ay<cmd>call GrepImportCtor(@a)<cr>
nnoremap <silent> gaq <cmd>call GrepImportQualified('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gaq "ay<cmd>call GrepImportQualified(@a)<cr>
nnoremap <silent> gaf <cmd>call GrepFuncDef('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gaf "ay<cmd>call GrepFuncDef(@a)<cr>

let g:haskell_sort_imports = match(getcwd(), 'code/tek/haskell') != -1

let g:myo_haskell_nix_default_hpack = 'ops/hpack.zsh'

function! Hpack() abort "{{{
  MyoRun hpack
endfunction "}}}

if filereadable('default.nix')
  call haskell#nix_project#setup()
else
  nnoremap <silent> <f5> :MyoRun stack-test<cr>
  nnoremap <silent> <s-f5> :MyoRun stack-test-lenient<cr>
  nnoremap <silent> <f17> :MyoRun stack-test-lenient<cr>
  nnoremap <silent> <f6> :MyoRun stack-build<cr>
  nnoremap <silent> <s-f6> :MyoRun stack-build-lenient<cr>
  nnoremap <silent> <f18> :MyoRun stack-build-lenient<cr>
  nnoremap <silent> <f7> :MyoRun stack-clean<cr>
  nnoremap <silent> <s-f7> :MyoRun stack-clean-all<cr>
  nnoremap <silent> <f19> :MyoRun stack-clean-all<cr>
endif
