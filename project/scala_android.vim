let g:sbt_projects = [
      \ ['integration', 'protify', 'test:compile'],
      \ ['debug', 'protify'],
      \ ['unit', 'test', 'test:compile'],
      \ ['release', 'android:run'],
      \ ]

let s:override = exists("g:override_project_android")

if !s:override
  ProAdd scala/droid
endif
