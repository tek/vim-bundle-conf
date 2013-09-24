let g:unite_split_rule = 'botright'
let g:unite_source_history_yank_enable = 1

autocmd BufEnter,WinEnter * set timeoutlen=1000

nnoremap <silent> <leader>b :Unite -auto-resize buffer<cr>

"{{{ ag
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nocolor --nogroup'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <silent> <leader>a :Unite -auto-resize -no-quit grep:.::<cr>
"}}}

nnoremap <silent> <m-u> :UniteResume<cr>
nnoremap <silent> <leader>; :Unite -auto-resize -start-insert source<cr>
nnoremap <silent> <m-/> :Unite -auto-resize line -start-insert -no-quit<cr>
nnoremap <silent> <m-e> :Unite -auto-resize file_rec/async -start-insert<cr>
nnoremap <silent> <leader>ur :Unite -auto-resize register<cr>
nnoremap <silent> <leader>uy :Unite -auto-resize history/yank<cr>
