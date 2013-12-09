setlocal omnifunc=jedi#completions

nnoremap <buffer><silent> <leader>jd :call jedi#goto_definitions()<cr>
nnoremap <buffer><silent> <leader>ja :call jedi#goto_assignments()<cr>
nnoremap <buffer><silent> <leader>jr :call jedi#rename()<cr>
nnoremap <buffer><silent> <leader>jn :call jedi#usages()<cr>
