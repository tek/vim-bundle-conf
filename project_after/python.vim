let g:syntastic_aggregate_errors=0

let g:maque_jump_to_error = 'last'

if !exists('g:maque_remote')
  let ipy = maque#tmux#add_pane('ipython', {
        \ 'eval_splitter': 0,
        \ '_splitter': 'tmux split-window -v -d -p 50', 
        \ 'capture': 0,
        \ 'autoclose': 0,
        \ 'vertical': 0,
        \ 'size': 50,
        \ 'minimized_size': 2,
        \ 'create_minimized': 0,
        \ 'restore_on_make': 0,
        \ 'focus_on_restore': 1,
        \ 'focus_on_make': 1,
        \ }
        \ )

  call maque#add_command('install deps', 'pip install -r requirements.txt')
  call maque#add_command('ipython', 'ipython3', { 'pane': 'ipython', })
  call maque#add_command('spec', 'spec', { 'pane': 'main', })
endif

nnoremap <silent> <leader><f3> :SaveAll<cr>:MaqueRunCommand install deps<cr>
nnoremap <silent> <leader><f4> :SaveAll<cr>:MaqueRunCommand ipython<cr>
nnoremap <silent> <f11> :MaqueToggleTmux ipython<cr>
nnoremap <silent> <leader><f5> :SaveAll<cr>:MaqueToggleTmux main<cr>:MaqueRunCommand ipython<cr>
nnoremap <silent> <leader><f6> :SaveAll<cr>:MaqueRunCommand spec<cr>

let g:pymport_paths += glob('$VIRTUAL_ENV/lib/python*/site-packages', 0, 1)
let g:pymport_package_precedence = ['tests', g:project_name, 'tek_utils', 'tek']
