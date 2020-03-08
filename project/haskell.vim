let g:neomake_haskell_enabled_makers = ['hdevtools']
let g:proteome_tags_command = 'codex'
let g:proteome_tags_args = 'update'

let g:myo_test_lang = 'haskell'
let g:test#runners = { 'haskell': ['htf', 'tasty'] }
let g:test#enabled_runners = ['haskell#htf', 'haskell#tasty']
let g:htf = v:true

let g:output_patterns += ['\bprint\b', '\bdbg[sm]?\b', '\bdbgm?With\b']
let g:output_file_patterns += ['\.hs']


function! HaskellFiles() abort "{{{
  let test_dirs = glob('**/test/', 0, 1)
  let lib_dirs = glob('**/lib/', 0, 1)
  execute 'ProFiles ' . join(test_dirs + lib_dirs, ' ')
endfunction "}}}

nnoremap <silent> <leader>e <cmd>call HaskellFiles()<cr>
nnoremap <silent> <localleader>e :ProFiles<cr>
