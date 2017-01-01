ProAdd scala/droid
ProAdd scala/pulsar

let s:sbt_project_map =
      \ {
      \   'debug': {
      \     'scope': {
      \       'run': 'protify',
      \     },
      \     'command': {
      \       'run': 'install',
      \     },
      \   },
      \   'release': {
      \     'scope': {
      \       'install': 'android',
      \       'run': 'android',
      \     },
      \   },
      \   'integration': {
      \     'scope': {
      \       'run': 'protify',
      \     },
      \     'command': {
      \       'run': 'install',
      \     },
      \   },
      \ }

call extend(g:sbt_project_map, s:sbt_project_map)
