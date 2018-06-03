call virtualenv#activate('')

let g:ctrlp_custom_ignore['dir'] .= '|<%(_?temp)>'

let g:output_patterns += ['(^\\s*print|log\\.test)\\(|\\.dbg\\b|self\\._p\\b']
let g:output_file_patterns += ['\\*.py', '\\*.coco']

if g:crm_dev
  MyoAddSystemCommand { "ident": "deps", "line": "pip install --no-cache -r requirements.txt" }
  MyoAddSystemCommand { "ident": "unit", "line": "klk unit", "langs": ["python"] }
  MyoAddSystemCommand { "ident": "integration", "line": "klk integration", "langs": ["python"] }
  MyoCreatePane {
        \ "name": "ipython",
        \ "layout": "make",
        \ "minimized": true,
        \ "minimized_size": 10,
        \ "fixed_size": 25
        \ }
  MyoAddSystemCommand { "ident": "ipython", "line": "ipython", "pane": "ipython" }
endif
