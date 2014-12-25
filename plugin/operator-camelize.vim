nnoremap <plug>(downcase-initial) bgul
map <plug>(operator-mixed-camelize) <Plug>(operator-camelize)iw<plug>(downcase-initial)
map <leader>cc <Plug>(operator-camelize)iw
map <leader>cs <Plug>(operator-decamelize)iw
map <leader>cm <plug>(operator-mixed-camelize):call repeat#set("\<leader>cm")<cr>
