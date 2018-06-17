let g:neomake_python_enabled_makers = ['flake8', 'mypy']
let g:neomake_coconut_enabled_makers = ['mypy']

let s:mypy_args = [
      \  '--follow-imports=silent', '--incremental',
      \  '--strict-optional',
      \  '--warn-redundant-casts', '--warn-no-return', '--warn-unused-ignores',
      \  '--show-error-context', '--show-column-numbers', '--check-untyped-defs',
      \  '--disallow-untyped-calls', '--disallow-untyped-defs',
      \ ]

let s:mypy_efm = '%f:%l:%c: %m,%f:%l: %m,%-G%.%#'

let g:neomake_python_mypy_maker = {
      \ 'args': s:mypy_args + ['--python-version', '3.6'],
      \ 'errorformat': s:mypy_efm,
      \ }

let g:neomake_coconut_mypy_maker = {
      \ 'exe': 'coconut',
      \ 'args': ['--target', '3.6', '--strict', '--quiet', '--line-numbers', '%:p', '--mypy'] + s:mypy_args,
      \ 'errorformat': s:mypy_efm,
      \ 'append_file': 0,
      \ 'process_output': function('tek#bundle#python#coconut_mypy_process_output'),
      \ }

let g:pymport_paths += glob('$VIRTUAL_ENV/lib/python*/site-packages', 0, 1)
let g:pymport_package_precedence =
      \ [
      \ g:proteome_main_name,
      \ 'ribosome',
      \ 'amino',
      \ 'chiasma',
      \ 'unit',
      \ 'integration',
      \ 'tests',
      \ 'test',
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

if !g:crm_dev
  MyoShellCommand deps { 'line': 'pip install --no-cache -r requirements.txt' }
  MyoShellCommand unit { 'line': 'var:spec_unit', 'eval': True, 'langs': ['python'] }
  MyoShellCommand integration { 'line': 'var:spec_integration', 'eval': True, 'langs': ['python'] }
  MyoTmuxCreatePane ipython {
        \ 'parent': 'main',
        \ 'minimized': 1,
        \ 'minimized_size': 10,
        \ 'fixed_size': 25,
        \ 'signals': ['kill'],
        \ }
  MyoShell ipython { 'line': 'ipython', 'target': 'ipython', 'history': False }
endif

nnoremap <silent> <s-f1> :MyoRun deps<cr>
nnoremap <silent> <s-f2> :MyoRun ipython<cr>
nnoremap <silent> <f5> :MyoRun unit<cr>
nnoremap <silent> <f6> :MyoRun integration<cr>
" nnoremap <silent> <f8> :MyoTmuxFocus ipython<cr>

let g:test#runners = {
      \ 'python': ['Klk', 'Spec']
      \ }
let test#python#runner = 'klk'
let g:spec_unit = 'klk unit'
let g:spec_integration = 'klk integration'

let g:myo_first_error = ['py:myo_bundle.FirstErrorPy']
let g:myo_output_filters = ['py:myo_bundle.FilterPy']
let g:myo_path_truncator = 'py:myo_bundle.truncate_py'

ProAdd! python/amino
