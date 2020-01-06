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

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <leader>ct <Plug>(coc-type-definition)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cr <Plug>(coc-references)
nmap <silent> <leader>cR <cmd>CocRestart<cr>
nmap <leader>ca <Plug>(coc-codeaction)
nmap <leader>cf <Plug>(coc-fix-current)
nmap <leader>cs <cmd>CocList -I symbols<cr>
nnoremap <silent> <leader>cn <cmd>CocCommand document.renameCurrentWord<cr>

inoremap <silent><expr> <c-space> coc#refresh()
