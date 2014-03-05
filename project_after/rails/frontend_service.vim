let g:maque_command = 'rspec --drb'
let &makeprg = g:maque_command . ' spec/features'
call maque#tmux#add_pane('thin', { '_splitter': 'tmux neww -d' })
call maque#tmux#add_pane('spork', { '_splitter': 'tmux neww -d' })
call maque#add_command('thin', 'MOCK=1 thin start', { 'pane': 'thin', })
call maque#add_command('spork', 'spork', { 'pane': 'spork', })
