let g:maque_jump_to_error = 'last'

call virtualenv#activate('')

let g:ctrlp_custom_ignore['dir'] .= '|<%(_temp)>'

let g:output_patterns += ['(^\\s*print|log\\.verbose)\\(|\\.dbg\\b|self\\._p\\b']
let g:output_file_patterns += ['\\*.py']
