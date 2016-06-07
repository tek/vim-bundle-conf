" setlocal omnifunc=jedi#completions
" setlocal omnifunc=

nnoremap <buffer><silent> gd :call jedi#goto_definitions()<cr>
nnoremap <buffer><silent> <localleader>d :call jedi#show_documentation()<cr>
nnoremap <buffer><silent> <localleader>a :call jedi#goto_assignments()<cr>
nnoremap <buffer><silent> <localleader>r :call jedi#rename()<cr>
nnoremap <buffer><silent> <localleader>u :call jedi#usages()<cr>
