let g:ctrlp_map = '<leader>e'
let g:ctrlp_working_path_mode = ''
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_max_height = 30

if expand('%:p') =~ $HOME && getcwd() == $HOME
  let dir = substitute(expand('%:p'), $HOME.'/[^/]\+/\zs.*', '', '')
  let g:ctrlp_cmd = 'CtrlP '.dir
endif
