let g:sbt_projects = [['mongo'], ['core'], ['root']]

let s:sbt_project_map =
      \ {
      \   'root': g:sbt_project_test,
      \   'mongo': g:sbt_project_test,
      \   'core': g:sbt_project_test,
      \ }

call extend(g:sbt_project_map, s:sbt_project_map)
