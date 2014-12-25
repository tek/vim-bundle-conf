nmap <silent> <leader>tq <Plug>(maque-query)
nmap <silent> <f2> <Plug>(maque-auto)
nmap <silent> <f3> <Plug>(maque-parse)zvzz
nmap <silent> <f4> <Plug>(maque)
nmap <silent> <f9> <Plug>(maque-tmux-toggle-layout)
nmap <silent> <f10> <Plug>(maque-tmux-kill)
nmap <silent> <leader>mc <Plug>(maque-tmux-close)
nmap <silent> <leader>4 <plug>(maque-tmux-focus)

nmap <silent> <leader><f1> <Plug>(maque-unite-stopped-command)
nmap <silent> <leader><f2> <plug>(maque-unite-open-tmux-pane)
nmap <silent> <leader><f3> :MaqueUniteCommandAll -no-quit<cr>
nmap <silent> <leader><f4> <plug>(maque-unite-tmux-pane)

nmap <silent> <leader>tf <Plug>(maque-file)
nmap <silent> <leader>tl <Plug>(maque-line)
nmap <silent> <leader>ta <Plug>(maque-all)

autocmd User MaqueTmuxMake SaveAll
