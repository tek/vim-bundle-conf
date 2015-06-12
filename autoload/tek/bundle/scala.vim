function! tek#bundle#scala#set_project() abort "{{{
  let data = get(g:scala_projects, g:scala_current_project, [])
  let g:sbt_prefix = get(data, 0, '')
  let runner = get(data, 1, 'run')
  let p_compiler = get(data, 2, 'compile')
  let prefix = g:sbt_prefix == '' ? g:sbt_prefix : g:sbt_prefix . '/'
  let g:sbt_compile = prefix . p_compiler
  if runner[0] == '~'
    let g:sbt_run = runner[0] . prefix . runner[1:]
  else
    let g:sbt_run = prefix . runner
  endif
  let g:maque_prefix_test_only = prefix
  let g:maque_prefix_android_test_only = prefix
  if len(g:sbt_prefix)
    echo 'sbt project ''' . g:sbt_prefix . ''''
  else
    echo 'sbt root project'
  endif
  if exists('g:project_android')
    let cmd = (prefix =~ 'release') ? 'setRelease' : 'setDebug'
    " call tek#bundle#scala#sbt(prefix . 'android:' . cmd)
  endif
endfunction "}}}

function! tek#bundle#scala#cycle_projects() abort "{{{
  let g:scala_current_project = (g:scala_current_project + 1) %
        \ len(g:scala_projects)
  call tek#bundle#scala#set_project()
endfunction "}}}

function! tek#bundle#scala#sbt(cmd) abort "{{{
  let g:sbt_command = a:cmd
  MaqueRunCommand sbt command
endfunction "}}}
