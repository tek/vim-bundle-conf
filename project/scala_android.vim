if g:project_name != 'droid'
  set tags+=~/code/scala/droid/.tags
endif

set tags+=~/code/scala/macroid/.tags

let g:scala_projects = [
      \ ['debugf', 'android:run'],
      \ ['unitf', 'test', 'test:compile'],
      \ ['integrationf', 'android:install'],
      \ ['releasef', 'android:run'],
      \ ]
