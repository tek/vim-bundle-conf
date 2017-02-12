" nmap Sa <Plug>(operator-surround-append)
" nmap Sr <Plug>(operator-surround-replace)
" nmap Sd <Plug>(operator-surround-delete)

" nmap <leader>s <Plug>(operator-surround-append)iw
" nmap <m-s> <Plug>(operator-surround-append)iW

" nmap <silent> <leader>C viwolB<Plug>(operator-surround-append))X

" " remove/change function call, cursor on function name, leave args
" nmap dC lbdt("_sd):call repeat#set('dC')<cr>
" nnoremap cC lbct(

" function! s:wrap(obj) "{{{
"   exe "normal \<Plug>(operator-surround-append)i".a:obj .')'
"   startinsert
"   call tek_misc#repeat_insert('\<Plug>(operator-surround-append)i'.a:obj .')')
" endfunction "}}}

" " wrap word/WORD with a function call, leaving cursor in insert at the
" " first paren
" nnoremap <leader>ww :call <SID>wrap('w')<cr>
" nnoremap <leader>wW :call <SID>wrap('W')<cr>

" function! s:wrap_object(type, ...) abort "{{{
"   silent exe "normal! `[v`]y"
"   execute "normal gv\<Plug>(operator-surround-append))"
"   startinsert
" endfunction "}}}

" nnoremap <silent> <leader>w :set opfunc=<sid>wrap_object<cr>g@

" " same for visual
" vmap <leader>w <Plug>(operator-surround-append))i
