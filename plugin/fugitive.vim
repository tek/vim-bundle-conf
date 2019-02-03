nnoremap <silent> <leader>gd :MyoToggleLayout make<cr>:Gvdiff<cr>
" nnoremap <silent> <leader>1 :call tek_misc#cleanup()<cr>:Git! diff<cr>zR:Gstatus<cr>
nnoremap <silent> <leader>gc :call tek_misc#cleanup()<cr>:Git! diff --cached<cr>zR:Gcommit<cr>
