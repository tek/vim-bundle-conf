call virtualenv#activate('')

let g:ctrlp_custom_ignore['dir'] .= '|<%(_?temp)>'

let g:output_patterns += ['(^\s*print|log\.test)\((?!.*file=.*stderr)']
let g:output_file_patterns += ['\.py', '\.coco']

let g:myo_test_langs = ['python']
MyoAddSystemCommand { "ident": "deps", "line": "pip install --no-cache -r requirements.txt", "target": "make" }
MyoAddSystemCommand { "ident": "unit", "line": "klk unit", "langs": ["python"], "target": "make" }
MyoAddSystemCommand { "ident": "integration", "line": "klk integration", "langs": ["python"], "target": "make" }
MyoCreatePane {
      \ "ident": "ipython",
      \ "layout": "make",
      \ "minimized": true,
      \ "minimized_size": 10,
      \ "fixed_size": 25
      \ }
MyoAddSystemCommand { "ident": "ipython", "line": "ipython", "pane": "ipython" }
