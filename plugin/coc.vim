function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:fix_next() abort "{{{
  execute "normal \<plug>(coc-fix-current)"
  sleep 100m
  execute "normal \<plug>(coc-diagnostic-next)"
endfunction "}}}

nmap <silent> gd <plug>(coc-definition)
nnoremap <silent> K :call <SID>show_documentation()<CR>
xnoremap <silent> K :call <SID>show_documentation()<CR>

autocmd CursorHold * silent! call CocActionAsync('highlight')

nmap <silent> ( <plug>(coc-diagnostic-prev)
nmap <silent> ) <plug>(coc-diagnostic-next)
nmap <silent> <leader>ct <plug>(coc-type-definition)
nmap <silent> <leader>ci <plug>(coc-implementation)
nmap <silent> <leader>cr <plug>(coc-references)
nmap <silent> <leader>cR <cmd>CocRestart<cr>
nmap <leader>ca <plug>(coc-codeaction)
nmap <leader>cl <plug>(coc-codelens-action)
nmap <silent> <m-f> <plug>(coc-fix-current)
nmap <silent> & <cmd>call <sid>fix_next()<cr>
nmap <leader>cs <cmd>CocList -I symbols<cr>
nnoremap <silent> <leader>cn <cmd>CocCommand document.renameCurrentWord<cr>

inoremap <silent><expr> <c-space> coc#refresh()

let g:coc_snippet_next = '<c-l>'
let g:coc_snippet_prev = '<c-h>'
