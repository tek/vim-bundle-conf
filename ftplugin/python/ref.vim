if tek_misc#is_mapped('K', 'n')
  silent! nunmap K
endif
nnoremap <silent><buffer> <Plug>tek_python_reference :call tek_python#reference()<cr>
nmap <silent><buffer> K <Plug>tek_python_reference
