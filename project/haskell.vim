let g:neomake_haskell_enabled_makers = ['hdevtools']
let g:proteome_tags_command = 'codex'
let g:proteome_tags_args = 'update'

let g:test#runners = {
      \ 'haskell': ['Htf']
      \ }

let g:output_patterns += ['\bprint\b', '\bLog\.infoS?\b', '\bLog\.p\b', '^\s+dbgs\b']
let g:output_file_patterns += ['\.hs']

set path+=./lib
set suffixesadd+=.hs

nnoremap <silent> <leader>e :execute 'CtrlP ' . haskell#project#lib_dir()<cr>
nnoremap <silent> <localleader>e :execute 'CtrlP'<cr>
