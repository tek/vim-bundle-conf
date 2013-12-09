call maque#tmux#add_pane('guard', { 'capture': 0, })
call maque#add_command('guard', 'guard', { 'pane': 'guard', })
call maque#make('guard')
