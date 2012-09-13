let g:ctrlp_map = '<leader>e'
let g:ctrlp_working_path_mode = ''

if expand('%:p') =~ $HOME.'/.vim'
  let g:ctrlp_root_markers = ['vim.vim']
  let g:ctrlp_working_path_mode = 'r'
endif
