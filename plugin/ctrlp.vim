let g:ctrlp_map = '<leader>e'
let g:ctrlp_working_path_mode = ''
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = '1r'

if expand('%:p') =~ $HOME.'/.vim' && getcwd() == $HOME
  let g:ctrlp_root_markers = ['vim.vim']
  let g:ctrlp_working_path_mode = 'r'
endif
