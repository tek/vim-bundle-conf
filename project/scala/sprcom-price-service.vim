let g:sbt_projects = [['core']]

let s:sbt_project_map =
      \ {
      \   'core': g:sbt_project_test,
      \ }

call extend(g:sbt_project_map, s:sbt_project_map)
