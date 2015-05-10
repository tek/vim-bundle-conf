let g:ctrlp_map = '<leader><insert>'
let g:ctrlp_working_path_mode = ''
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_max_height = 30
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v<\.%(git|hg|svn)>',
  \ 'file': '\v\.%(exe|so|dll|png)>',
  \ 'link': '',
  \ }

nnoremap <silent> <leader>e :call tek_bundle_misc#ctrlp()<cr>
