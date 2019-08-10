let g:ctrlp_map = '<leader><insert>'
let g:ctrlp_working_path_mode = ''
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_max_height = 30

if !exists('g:ctrlp_custom_ignore')
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v',
    \ 'file': '\v',
    \ 'link': '\v',
    \ }
else
  let i = g:ctrlp_custom_ignore
  let g:ctrlp_custom_ignore['dir'] = '\v' . i['dir']
  let g:ctrlp_custom_ignore['file'] = '\v' . i['file']
  let g:ctrlp_custom_ignore['link'] = '\v' . i['link']
endif

let g:ctrlp_custom_ignore['dir'] .= '\.git>|/build>|<target>|<vendor>|' . $PWD . '/node_modules'
let g:ctrlp_custom_ignore['file'] .= '\.%(png|jpg)$|LICENSE'

" nnoremap <silent> <leader>e :CtrlP<cr>
