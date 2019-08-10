let g:neomake_haskell_enabled_makers = ['hdevtools']
let g:proteome_tags_command = 'codex'
let g:proteome_tags_args = 'update'

let g:myo_test_lang = 'haskell'
let g:test#runners = {
      \ 'haskell': ['Htf']
      \ }

let g:output_patterns += ['\bprint\b', '\bdbg[sm]?\b', '\bdbgm?With\b']
let g:output_file_patterns += ['\.hs']

set path+=./lib
set suffixesadd+=.hs

nnoremap <silent> <leader>e :execute 'ProFiles ' . haskell#project#lib_dir()<cr>
nnoremap <silent> <localleader>e :ProFiles<cr>
