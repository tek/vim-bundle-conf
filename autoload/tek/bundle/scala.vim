function! tek#bundle#scala#set_project() abort "{{{
  let data = get(g:sbt_projects, g:sbt_current_project, [])
  let g:sbt_prefix = get(data, 0, 'root')
  let runner = get(data, 1, 'run')
  let p_compiler = get(data, 2, 'compile')
  let prefix = g:sbt_prefix == '' ? g:sbt_prefix : g:sbt_prefix . '/'
  let g:sbt_compile = tek#bundle#scala#sbt_prefixed(p_compiler)
  let g:sbt_run = tek#bundle#scala#sbt_prefixed(runner)
  let g:maque_prefix_test_only = prefix
  let g:maque_prefix_android_test_only = prefix
  if len(g:sbt_prefix)
    echo 'sbt project ''' . g:sbt_prefix . ''''
  else
    echo 'sbt root project'
  endif
endfunction "}}}

function! tek#bundle#scala#cycle_projects(...) abort "{{{
  let diff = get(a:, 0, 1)
  let g:sbt_current_project = (g:sbt_current_project + diff) %
        \ len(g:sbt_projects)
  call tek#bundle#scala#set_project()
endfunction "}}}

function! tek#bundle#scala#sbt(cmd) abort "{{{
  let g:sbt_command = a:cmd
  MaqueRunCommand sbt command
endfunction "}}}

function! tek#bundle#scala#add_project(name) abort "{{{
  call tek_bundle_misc#add_root_project(g:scala_project_dir . '/' . a:name)
endfunction "}}}

function! tek#bundle#scala#sbt_prefixed(cmd) abort "{{{
  let prefix = g:sbt_prefix == '' ? '' : g:sbt_prefix . '/'
  if a:cmd[0] == '~'
    return a:cmd[0] . prefix . runner[1:]
  else
    return prefix . a:cmd
  endif
endfunction "}}}

function! tek#bundle#scala#add_sbt_project(path, ...) abort "{{{
  let params = a:0 ? a:000 : ['test', 'test:compile']
  let g:sbt_projects += [[a:path] + params]
  let g:sbt_current_project = -1
  call tek#bundle#scala#set_project()
endfunction "}}}

function! tek#bundle#scala#activate_sbt_project(name) abort "{{{
  let cmd = 'project {file:' . g:scala_project_dir . '/' . a:name . '}'
  call tek#bundle#scala#sbt(cmd)
endfunction "}}}
