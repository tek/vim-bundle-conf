if g:project_name != 'core'
  set tags+=~/code/scala/core/.tags
endif

let g:scala_use_default_keymappings = 0

if !exists('g:project_android')
  let g:sbt_compile = 'compile'
  let g:sbt_run = 'run'
  let g:sbt_test = 'test'
endif

if !exists('g:scala_projects')
  let g:scala_projects = []
endif

let g:scala_current_project = 0

command! -bar CycleProjects call tek#bundle#scala#cycle_projects()

nnoremap <silent> <home> :CycleProjects<cr>
