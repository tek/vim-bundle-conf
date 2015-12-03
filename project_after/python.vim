let g:syntastic_aggregate_errors=0

let g:maque_jump_to_error = 'last'

function! s:setup_maque() abort "{{{
  let ipy = {
        \ 'eval_splitter': 0,
        \ '_splitter': 'tmux split-window -v -d -p 50',
        \ 'capture': 0,
        \ 'autoclose': 0,
        \ 'vertical': 0,
        \ 'size': 15,
        \ 'minimized_size': 2,
        \ 'create_minimized': 0,
        \ 'restore_on_make': 0,
        \ 'focus_on_restore': 1,
        \ 'focus_on_make': 1,
        \ }
  call maque#tmux#add_pane_in_layout('ipython', 'make', ipy)
  call maque#create_command('install deps', 'pip install -r requirements.txt')
  call maque#create_command('ipython', 'ipython3', { 'pane': 'ipython', })
  call maque#create_command('spec', 'spec', { 'pane': 'main', })
endfunction "}}}

augroup maque_python_project
  autocmd!
  autocmd User MaqueTmuxDefaultPanesCreated call <sid>setup_maque()
augroup END

nnoremap <silent> <s-f1> :SaveAll<cr>:MaqueRunCommand install deps<cr>
nnoremap <silent> <s-f2> :SaveAll<cr>:MaqueToggleCommand ipython<cr>
nnoremap <silent> <s-f3> :SaveAll<cr>:MaqueRunCommand spec<cr>
nnoremap <silent> <f8> :MaqueTmuxFocus ipython<cr>

let g:pymport_paths += glob('$VIRTUAL_ENV/lib/python*/site-packages', 0, 1)
let g:pymport_package_precedence = ['tests', g:project_name, 'tek_utils', 'tek']
