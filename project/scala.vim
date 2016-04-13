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

command! -bar NextProject call tek#bundle#scala#cycle_projects(1)
command! -bar PrevProject call tek#bundle#scala#cycle_projects(-1)
command! -bar -nargs=+ AddSbtProject call
      \ tek#bundle#scala#add_sbt_project(<f-args>)
command! -bar -nargs=0 ActivateSbtProject call
      \ tek#bundle#scala#activate_sbt_project(g:proteome_active.name)

nnoremap <silent> <home> :NextProject<cr>
nnoremap <silent> <end> :PrevProject<cr>
nnoremap <silent> <s-home> :ActivateSbtProject<cr>

let s:override = exists("g:override_project_scala")
