function! tek#bundle#scala#set_project() abort "{{{
  let [prefix, runner] = g:scala_projects[g:scala_current_project]
  let g:sbt_compile = prefix . '/compile'
  let g:sbt_run = prefix . '/' . runner
  let g:sbt_prefix = prefix
  echo 'sbt project ''' . prefix . ''''
endfunction "}}}

function! tek#bundle#scala#cycle_projects() abort "{{{
  let g:scala_current_project = (g:scala_current_project + 1) %
        \ len(g:scala_projects)
  call tek#bundle#scala#set_project()
endfunction "}}}
