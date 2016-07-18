let g:neomake_python_enabled_makers = ['flake8', 'mypy']

let g:neomake_python_mypy_maker = {
    \ 'args': ['--silent-imports'],
    \ 'errorformat': '%f:%l: %m',
    \ }

let g:pymport_paths += glob('$VIRTUAL_ENV/lib/python*/site-packages', 0, 1)
let g:pymport_package_precedence =
      \ [
      \ 'unit',
      \ 'integration',
      \ 'tests',
      \ g:project_name,
      \ 'trypnv',
      \ 'tryp',
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

MaqueAddCommand 'pip install -r requirements.txt', { 'name': 'deps' }
MaqueAddCommand 'spec unit', { 'name': 'spec_unit' }
MaqueAddCommand 'spec integration', { 'name': 'spec_integration' }

MaqueAddShell 'ipython3', {
      \ 'start': 0,
      \ 'create_minimized': 1,
      \ 'minimized_size': 25,
      \ 'size': 48,
      \ 'compiler': 'python',
      \ 'kill_signals': ['KILL'],
      \ }

nnoremap <silent> <s-f1> :SaveAll<cr>:MaqueRunCommand deps<cr>
nnoremap <silent> <s-f2> :SaveAll<cr>:MaqueToggleCommand ipython3<cr>
nnoremap <silent> <f5> :SaveAll<cr>:MaqueRunCommand spec_unit<cr>
nnoremap <silent> <f6> :SaveAll<cr>:MaqueRunCommand spec_integration<cr>
nnoremap <silent> <f8> :MaqueTmuxFocus ipython<cr>
