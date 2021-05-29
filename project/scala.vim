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

let s:code = $HOME . '/code/'

let g:scala_project_dirs = [s:code . 'tek/scala', s:code . 'ext/scala']
let g:main_scala_project_dir = g:scala_project_dirs[0]

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

let g:test#runners = { 'scala': ['specs2'] }
let g:test#enabled_runners = ['scala#specs2']
let g:myo_test_shell = 'sbt'
let g:myo_output_jump_first = v:true

let g:sbt_project_test = {
      \   'scope': {
      \     'compile': 'test',
      \   },
      \   'command': {
      \     'run': 'test',
      \   },
      \ }

let g:sbt_project_map =
      \ {
      \   'default': g:sbt_project_test,
      \ }

let g:scala_integration_rex = 'integration'

let g:proteome_files_exclude_directories += ['target', 'out']

command! ImportBuild call CocRequestAsync('metals', 'workspace/executeCommand', { 'command': 'build-import' })
