function! Gitdiff() abort "{{{
  call MyoToggleLayout('make')
  sleep 200m
  Gvdiff
endfunction "}}}

nnoremap <silent> <leader>gd :call Gitdiff()<cr>
" nnoremap <silent> <leader>1 :call tek_misc#cleanup()<cr>:Git! diff<cr>zR:Gstatus<cr>
nnoremap <silent> <leader>gc :call tek_misc#cleanup()<cr>:Git! diff --cached<cr>zR:Gcommit<cr>
