let g:sbt_projects = [
      \ ['debug', 'protify'],
      \ ['unit', 'test', 'test:compile'],
      \ ['integration', 'protify', 'test:compile'],
      \ ['release', 'android:run'],
      \ ]

let s:override = exists("g:override_project_android")

if !s:override
  ProAdd scala/droid
endif
