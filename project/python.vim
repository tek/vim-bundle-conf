let g:neomake_python_enabled_makers = ['flake8', 'mypy']

let g:neomake_python_mypy_maker = {
    \ 'args': [
    \  '--follow-imports=skip', '--fast-parser', '--incremental',
    \  '--strict-optional',
    \  '--warn-redundant-casts', '--warn-no-return', '--warn-unused-ignores',
    \  '--show-error-context', '--show-column-numbers', '--check-untyped-defs',
    \ ],
    \ 'errorformat': '%f:%l:%c: %m,%f:%l: %m',
    \ }
" '--disallow-untyped-calls',

let g:pymport_paths += glob('$VIRTUAL_ENV/lib/python*/site-packages', 0, 1)
let g:pymport_package_precedence =
      \ [
      \ 'unit',
      \ 'integration',
      \ 'tests',
      \ g:project_name,
      \ 'ribosome',
      \ 'amino',
      \ 'golgi',
      \ 'tek_utils',
      \ 'tek',
      \ ]

if exists('g:pyenv_python_dir')
  let g:pymport_paths +=
        \ glob(g:pyenv_python_dir . '/lib/python*/site-packages', 0, 1)
endif

function! s:project_added() abort "{{{
  if exists('g:proteome_added_project')
    let root = g:proteome_added_project.root
    let g:pymport_paths = [root] + g:pymport_paths
    let $PYTHONPATH = root . ':' . $PYTHONPATH
    let &path = root . ',' . &path
    execute 'python3 sys.path.insert(0, '''. root . ''')'
  endif
endfunction "}}}

augroup tek_bundle_python_project
autocmd!
autocmd User ProteomeAdded call <sid>project_added()
augroup END

let g:syntastic_aggregate_errors=0

MyoShellCommand deps { 'line': 'pip install -r requirements.txt' }
MyoShellCommand unit { 'line': 'spec unit' }
MyoShellCommand integration { 'line': 'spec integration' }
MyoTmuxCreatePane ipython {
      \ 'parent': 'main',
      \ 'minimized': 1,
      \ 'minimized_size': 10,
      \ 'fixed_size': 25,
      \ 'signals': ['kill'],
      \ }
MyoShell ipython { 'line': 'ipython', 'target': 'ipython', 'history': False }

nnoremap <silent> <s-f1> :MyoRun deps<cr>
nnoremap <silent> <s-f2> :MyoRun ipython<cr>
nnoremap <silent> <f5> :MyoRun unit<cr>
nnoremap <silent> <f6> :MyoRun integration<cr>
nnoremap <silent> <f8> :MyoTmuxFocus ipython<cr>

let g:test#runners = {
      \ 'python': ['Spec']
      \ }
let test#python#runner = 'spec'

let g:myo_first_error = ['py:myo_bundle.FirstErrorPy']
let g:myo_output_filters = ['py:myo_bundle.FilterPy']
let g:myo_path_truncator = 'py:myo_bundle.truncate_py'
