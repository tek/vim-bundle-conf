let g:scala_use_default_keymappings = 0

if !exists('g:project_android')
  let g:sbt_compile = 'compile'
  let g:sbt_run = 'run'
  let g:sbt_test = 'test'
endif

if !exists('g:sbt_projects')
  let g:sbt_projects = []
endif

let g:sbt_current_project = 0

let g:scala_project_dir = $HOME . '/code/scala'

command! -bar CycleProjects call tek#bundle#scala#cycle_projects()
command! -bar -nargs=+ AddSbtProject call
      \ tek#bundle#scala#add_sbt_project(<f-args>)

nnoremap <silent> <home> :CycleProjects<cr>

let s:override = exists("g:override_project_scala")
