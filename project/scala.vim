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

function! AddScalaProjects(...) abort "{{{
  for n in a:000
    execute 'ProAdd scala/' . n
  endfor
endfunction "}}}

command! -bar CycleProjects call tek#bundle#scala#cycle_projects()
command! -bar -nargs=+ AddSbtProject call
      \ tek#bundle#scala#add_sbt_project(<f-args>)
command! -bar -nargs=+ AddSbtRoot call AddScalaProjects(<f-args>)

nnoremap <silent> <home> :CycleProjects<cr>

nnoremap <silent> <leader>2 :Unite sbt_project -start-insert -auto-resize<cr>

let s:override = exists("g:override_project_scala")

if !s:override
  " ProAdd scala/pulsar
endif
