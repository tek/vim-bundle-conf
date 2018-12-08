let g:neomake_haskell_enabled_makers = ['hdevtools']
let g:proteome_tags_command = 'codex'
let g:proteome_tags_args = 'update'

let g:test#runners = {
      \ 'haskell': ['Htf']
      \ }

let g:output_patterns += ['\bprint\b', 'info', 'infoS']
let g:output_file_patterns += ['\.hs']

set path+=src/Lib
