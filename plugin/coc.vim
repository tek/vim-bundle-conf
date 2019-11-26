function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> K :call <SID>show_documentation()<CR>

autocmd CursorHold * silent! call CocActionAsync('highlight')

nmap <silent> <leader>ct <Plug>(coc-type-definition)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cr <Plug>(coc-references)
nmap <silent> <leader>cR <cmd>CocRestart<cr>
nmap <leader>ca <Plug>(coc-codeaction)
nmap <leader>cf <Plug>(coc-fix-current)
nmap <leader>cs <cmd>CocList -I symbols<cr>

inoremap <silent><expr> <c-space> coc#refresh()

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'
" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <tab> <Plug>(coc-snippets-expand-jump)
