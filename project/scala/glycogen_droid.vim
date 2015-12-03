let g:sbt_projects = [
      \ ['debug', 'protify'],
      \ ['unit', 'test', 'test:compile'],
      \ ['integration', 'android:install', 'test:compile'],
      \ ['release', 'android:run'],
      \ ]
let g:logcat_output_name = 'glyc'
