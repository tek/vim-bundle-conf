let g:sbt_projects = [
      \ ['debug', 'protify'],
      \ ['unit', 'test', 'test:compile'],
      \ ['integration', 'protify', 'test:compile'],
      \ ['release', 'android:run'],
      \ ]
