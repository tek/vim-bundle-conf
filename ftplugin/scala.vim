set textwidth=120

nmap <buffer><silent> <localleader>y <Plug>(coc-type-definition)
nmap <buffer><silent> <localleader>i <Plug>(coc-implementation)
nmap <buffer><silent> <localleader>r <Plug>(coc-references)

" Remap for rename current word
nmap <buffer> <localleader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <buffer> <localleader>f  <Plug>(coc-format-selected)
nmap <buffer> <localleader>f  <Plug>(coc-format-selected)
