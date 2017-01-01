silent! unmap [u
silent! unmap [uu
silent! unmap ]u
silent! unmap ]uu
nmap <expr> <silent> ]u ':<c-u>UniteResume<cr>'.v:count.'<Plug>(unite_loop_cursor_down)<Plug>(unite_do_default_action)'
nmap <expr> <silent> [u ':<c-u>UniteResume<cr>'.v:count.'<Plug>(unite_loop_cursor_up)<Plug>(unite_do_default_action)'
