call virtualenv#activate('')

let g:ctrlp_custom_ignore['dir'] .= '|<%(_?temp)>'

let g:output_patterns += ['(^\\s*print|log\\.test)\\(|\\.dbg\\b|self\\._p\\b']
let g:output_file_patterns += ['\\*.py', '\\*.coco']
