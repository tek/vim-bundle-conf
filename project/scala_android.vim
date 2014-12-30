if g:project_name != 'droid'
  set tags+=~/code/scala/droid/.tags
endif

let g:scala_projects = [
      \ ['debug', 'android:run'],
      \ ['unitf', 'test'],
      \ ['integrationf', 'android:test'],
      \ ]
let g:scala_current_project = 0

command! -bar CycleProjects call tek#bundle#scala#cycle_projects()

nnoremap <silent> <home> :CycleProjects<cr>

silent call tek#bundle#scala#set_project()
