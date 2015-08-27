let g:override_project_scala = 1

let g:sbt_projects = [
      \ ['unit', 'test', 'test:compile'],
      \ ['slick', 'test', 'test:compile'],
      \ ['slick-core', 'test', 'test:compile'],
      \ ]
