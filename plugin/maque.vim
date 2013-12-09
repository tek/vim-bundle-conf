nmap <leader>tq <Plug>(maque-query)
map <silent> <f2> <Plug>(save-all)<Plug>(auto-maque)
map <silent> <f6> <Plug>(save-all)<Plug>(maque)
nmap <silent> <f3> <Plug>(maque-parse)
nmap <silent> <f9> <Plug>(maque-toggle-tmux)
nmap <silent> <f10> <Plug>(maque-tmux-kill)
nnoremap <silent> <leader>tc :CtrlPMaque<cr>
nnoremap <silent> <leader>tp :CtrlPMaqueTmux<cr>
nmap <silent> <leader>mc <Plug>(maque-tmux-close)
