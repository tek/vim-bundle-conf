nmap <buffer> <esc> <Plug>(unite_exit)

nnoremap <silent><expr><buffer> D unite#smart_map('d', unite#do_action('delete'))
nnoremap <silent><expr><buffer> R unite#smart_map('r', unite#do_action('replace'))

" autocmd WinEnter <buffer> set timeoutlen=0
" set timeoutlen=0

silent! syntax clear IndentLine
