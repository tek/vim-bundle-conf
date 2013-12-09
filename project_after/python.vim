let g:syntastic_aggregate_errors=0

let g:maque_jump_to_error = 'last'

call maque#tmux#add_pane('ipython', {
      \ 'eval_splitter': 0,
      \ '_splitter': 'tmux split-window -v -d -p 50', 
      \ 'capture': 0,
      \ 'autoclose': 0,
      \ 'vertical': 0,
      \ 'minimized_size': 2,
      \ 'create_minimized': 1,
      \ 'restore_on_make': 0,
      \ 'focus_on_restore': 1,
      \ }
      \ )

call maque#add_command('install deps', 'pip install -r requirements.txt')
call maque#add_command('ipython', 'ipython3', { 'pane': 'ipython', })

nnoremap <silent> <leader><f1> :SaveAll<cr>:MaqueRunCommand install deps<cr>
nnoremap <silent> <leader><f2> :SaveAll<cr>:MaqueRunCommand ipython<cr>
nnoremap <silent> <f11> :MaqueToggleTmux ipython<cr>
nnoremap <silent> <leader><f5> :MaqueToggleTmux main<cr>:MaqueRunCommand ipython<cr>
