let g:neomake_haskell_enabled_makers = ['hdevtools']
let g:proteome_tags_command = 'codex'
let g:proteome_tags_args = 'update'

let g:myo_test_lang = 'haskell'
let g:test#runners = { 'haskell': ['htf', 'tasty'] }
let g:test#enabled_runners = ['haskell#htf', 'haskell#tasty']
let g:htf = v:true

let g:output_patterns += ['^ .*\bdbg[sm]?\b', '^ .*\bunsafeLog']
let g:output_file_patterns += ['\.hs']

function! s:test_dirs() abort "{{{
  return ['test', 'integration'] + glob('modules/*/test/', 0, 1) + glob('modules/*/integration/', 0, 1)
endfunction "}}}

function! s:lib_dirs() abort "{{{
  return ['lib', 'app'] + glob('modules/*/lib/', 0, 1) + glob('modules/*/app/', 0, 1)
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

nnoremap <silent> <leader>e <cmd>call HaskellFiles()<cr>
nnoremap <silent> <localleader>e :ProFiles<cr>
nnoremap <silent> gai <cmd>call GrepImport('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gai "ay<cmd>call GrepImport(@a)<cr>

let g:haskell_sort_imports = match(getcwd(), 'code/tek/haskell') != -1
