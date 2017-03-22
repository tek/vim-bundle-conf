ProAdd scala/pulsar

let g:sbt_projects = [
      \ ['unit'],
      \ ['unit-droid'],
      \ ['state'],
      \ ['view'],
      \ ['trial'],
      \ ['integration'],
      \ ]
let g:logcat_output_name = 'tryp'

let s:test = {
      \   'scope': {
      \     'compile': 'test',
      \   },
      \   'command': {
      \     'test': 'test',
      \   },
      \ }

let s:int = {
      \   'scope': {
      \     'test': 'protify',
      \   },
      \   'command': {
      \     'test': 'install',
      \   },
      \ }

let s:sbt_project_map =
      \ {
      \   'trial': {
      \     'scope': {
      \       'test': 'protify',
      \       'compile': 'protify',
      \     },
      \     'command': {
      \       'compile': 'install',
      \     },
      \   },
      \   'integration': s:int,
      \   'tstatei': s:int,
      \ }

call extend(g:sbt_project_map, s:sbt_project_map)

let g:scala_integration_rex = '\(integration\|tstatei\)'
