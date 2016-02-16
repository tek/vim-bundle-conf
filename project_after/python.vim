let g:maque_jump_to_error = 'last'

call virtualenv#activate('')

let g:ctrlp_custom_ignore['dir'] .= '|<%(_temp)>'

" if !exists('g:deoplete#omni#input_patterns')
"   let g:deoplete#omni#input_patterns = g:deoplete#omni#_input_patterns
" endif

" let g:deoplete#omni#input_patterns.python = [
"       \ '[^. \t0-9]\.\w*',
"       \ 'from \s+ import .*',
"       \ 'from \s*',
"       \ 'import \s*',
"       \ ]
