nmap <silent> <leader>tq <Plug>(maque-query)
nmap <silent> <f2> <Plug>(auto-maque)
nmap <silent> <f3> <Plug>(maque-parse)
nmap <silent> <f4> <Plug>(maque)
nmap <silent> <f9> <Plug>(maque-tmux-toggle-make)
nmap <silent> <f10> <Plug>(maque-tmux-kill)
nmap <silent> <leader>mc <Plug>(maque-tmux-close)

nmap <silent> <leader><f1> <plug>(maque-unite-command)
nmap <silent> <leader><f2> <plug>(maque-unite-tmux-pane)

autocmd User MaqueTmuxMake SaveAll
