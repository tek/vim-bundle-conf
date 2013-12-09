call maque#tmux#add_pane('emulator', { '_splitter': 'tmux neww -d' })
call maque#tmux#add_pane('log', {
      \ 'eval_splitter': 0,
      \ '_splitter': 'tmux split-window -v -d -p 60 "zsh -f"', 
      \ 'capture': 0,
      \ 'autoclose': 1,
      \ 'vertical': 0,
      \ 'minimized_size': 5,
      \ 'create_minimized': 1,
      \ 'restore_on_make': 0,
      \ }
      \ )

call maque#add_command('emulator', 'ruboto emulator', { 'pane': 'emulator', })
call maque#add_command('install', 'rake install', { 'pane': 'main', })
call maque#add_command('uninstall', 'rake uninstall', { 'pane': 'main', })
call maque#add_command('restart', 'rake update_scripts:restart', { 'pane': 'main', })

nnoremap <silent> <leader><f5> :SaveAll<cr>:MaqueRunCommand install<cr>
nnoremap <silent> <leader><f6> :SaveAll<cr>:MaqueRunCommand uninstall<cr>
nnoremap <silent> <leader><f7> :SaveAll<cr>:MaqueRunCommand restart<cr>
nnoremap <silent> <f11> :MaqueToggleTmux log<cr>

set path+=./src
