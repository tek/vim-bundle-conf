if expand('%:p') =~ $HOME.'/.vim'
  nnoremap <silent> <leader>e :exe 'CommandT '.$HOME.'/.vim'<cr>
else
  nnoremap <silent> <leader>e :CommandT<cr>
endif
