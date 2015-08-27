let g:sbt_projects = [
      \ ['debugf', 'android:run'],
      \ ['unitf', 'test', 'test:compile'],
      \ ['integrationf', 'android:install', 'test:compile'],
      \ ['releasef', 'android:run'],
      \ ]
