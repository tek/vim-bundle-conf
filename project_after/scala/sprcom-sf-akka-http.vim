let g:sbt_projects = [['route'], ['app'], ['core']]

let s:sbt_project_map =
      \ {
      \   'core': g:sbt_project_test,
      \   'route': g:sbt_project_test,
      \   'app': g:sbt_project_test,
      \ }

call extend(g:sbt_project_map, s:sbt_project_map)
