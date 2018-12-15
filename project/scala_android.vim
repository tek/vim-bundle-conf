let g:sbt_projects = [
      \ ['integration', 'protify', 'compile'],
      \ ['debug', 'protify'],
      \ ['unit', 'test', 'test:compile'],
      \ ['release', 'android:run'],
      \ ]

let s:override = exists("g:override_project_android")

if !s:override
  ProAdd scala/droid
endif

let s:int = {
      \   'scope': {
      \     'test': 'protify',
      \     'compile': 'compile',
      \   },
      \   'command': {
      \     'test': 'install',
      \   },
      \ }

let s:sbt_project_map =
      \ {
      \   'debug': {
      \     'scope': {
      \       'test': 'protify',
      \     },
      \     'command': {
      \       'test': 'install',
      \     },
      \   },
      \   'release': {
      \     'scope': {
      \       'install': 'android',
      \       'test': 'android',
      \     },
      \   },
      \   'integration': s:int,
      \ }

call extend(g:sbt_project_map, s:sbt_project_map)
