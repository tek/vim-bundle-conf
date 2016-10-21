let g:sbt_projects = [
      \ ['unit', 'test', 'test:compile'],
      \ ['unit-droid', 'test', 'test:compile'],
      \ ['state', 'test', 'test:compile'],
      \ ['view', 'test', 'test:compile'],
      \ ['trial', 'protify:run'],
      \ ]
let g:logcat_output_name = 'tryp'

let s:test = {
      \   'scope': {
      \     'compile': 'test',
      \   },
      \   'command': {
      \     'run': 'test',
      \   },
      \ }

let g:sbt_project_map =
      \ {
      \   'trial': {
      \     'scope': {
      \       'run': 'protify',
      \       'compile': 'protify',
      \     },
      \     'command': {
      \       'compile': 'install',
      \   },
      \   },
      \   'unit-droid': s:test,
      \   'unit': s:test,
      \ }
