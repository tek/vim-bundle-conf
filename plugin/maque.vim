nmap <leader>tq <Plug>(maque-query)
map <silent> <f2> :call tek_misc#save_all()<cr><Plug>(auto-maque)
map <silent> <f6> :call tek_misc#save_all()<cr><Plug>(maque)
nmap <silent> <f3> <Plug>(maque-parse)
nmap <silent> <f9> <Plug>(maque-toggle-tmux)
nmap <silent> <f10> <Plug>(maque-tmux-kill)
nmap <silent> <leader>tc :CtrlPMaque<cr>
nmap <silent> <leader>tp :CtrlPMaqueTmux<cr>
