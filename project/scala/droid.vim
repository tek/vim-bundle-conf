let g:sbt_projects = [
      \ ['unit', 'test', 'test:compile'],
      \ ['unit-droid', 'test', 'test:compile'],
      \ ['state', 'test', 'test:compile'],
      \ ['view', 'test', 'test:compile'],
      \ ['trial', 'protify:run'],
      \ ['integration', 'android:test'],
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

let s:sbt_project_map =
      \ {
      \   'trial': {
      \     'scope': {
      \       'run': 'protify',
      \       'compile': 'protify',
      \     },
      \     'command': {
      \       'compile': 'install',
      \     },
      \   },
      \   'integration': {
      \     'scope': {
      \       'run': 'android',
      \     },
      \     'command': {
      \       'run': 'install',
      \     },
      \   },
      \ }

call extend(g:sbt_project_map, s:sbt_project_map)

let g:scala_integration_rex = '\(integration\|tstatei\)'
