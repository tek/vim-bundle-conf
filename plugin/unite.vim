let g:unite_split_rule = 'botright'
let g:unite_source_history_yank_enable = 1

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

" autocmd BufEnter,WinEnter * set timeoutlen=1000

nmap <silent> <leader>b :Unite -auto-resize buffer<cr>

command! -bar -nargs=1 UniteAg Unite -auto-resize -no-quit grep:.::<args>

"{{{ ag
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nocolor --nogroup --skip-vcs-ignores'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_rec_async_command = "ag --nocolor --nogroup --skip-vcs-ignores --ignore '.hg' --ignore '.svn' --ignore '.git' --ignore '.bzr' --ignore '_darcs' -g ''"
endif

nnoremap <silent> <leader>aa :Unite -auto-resize -no-quit grep:.:-s:<cr>
nnoremap <silent> <leader>ai :Unite -auto-resize -no-quit grep:.:-i:<cr>
nnoremap <silent> <leader>ad :Unite -auto-resize -no-quit grep<cr>
nnoremap <silent> <leader>aA :Unite -auto-resize -no-quit grep:.:-t:<cr>
"}}}

nnoremap <silent> <m-u> :UniteResume<cr>
nnoremap <silent> <leader>uu :Unite -auto-resize source<cr>
nnoremap <silent> <leader>u/ :Unite -auto-resize line -start-insert -no-quit<cr>
nnoremap <silent> <m-e> :Unite -auto-resize file_rec/async -start-insert<cr>
nnoremap <silent> <leader>ur :Unite -auto-resize register<cr>
nnoremap <silent> <leader>uy :Unite -auto-resize history/yank<cr>
nnoremap <silent> <leader>ut :Unite -auto-resize -start-insert tag/include<cr>
