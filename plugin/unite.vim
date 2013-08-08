let g:unite_split_rule = 'botright'

nnoremap <silent> <leader>b :Unite -auto-resize buffer<cr>

"{{{ ag
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nocolor --nogroup'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <leader>a :Unite -auto-resize -no-quit grep:.::<cr>
"}}}
