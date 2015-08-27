let g:sbt_projects = [
      \ ['development', 'jetty:start', 'jetty:webappPrepare'],
      \ ['unit', 'test', 'test:compile'],
      \ ['integration', 'test', 'test:compile'],
      \ ]
