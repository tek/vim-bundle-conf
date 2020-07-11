" shortcut for surrounding inner word/WORD
nmap <leader>s csw
nmap S ys
nmap <m-s> csW

nmap <silent> <leader>C viwolB<Plug>VSurround)X

" remove/change function call, cursor on function name, leave args
nmap dC lbdt("_ds):call repeat#set('dC')<cr>
nnoremap cC lbct(

function! s:wrap(obj, char) "{{{
  exe "normal ysi".a:obj . a:char
  startinsert
  call tek_misc#repeat_insert('ysi'.a:obj . a:char)
endfunction "}}}

" wrap word/WORD with a function call, leaving cursor in insert at the
" first paren
nnoremap <leader>ww :call <SID>wrap('w', ')')<cr>
nnoremap <leader>wW :call <SID>wrap('W', ')')<cr>
nnoremap <leader>wb :call <SID>wrap('w', ']')<cr>
nnoremap <leader>wB :call <SID>wrap('W', ']')<cr>

function! s:wrap_object(char) abort "{{{
  silent exe "normal! `[v`]y"
  execute "normal gv\<Plug>VSurround" . a:char
  startinsert
endfunction "}}}

function! s:wrap_object_parens(type, ...) abort "{{{
  return s:wrap_object(')')
endfunction "}}}

function! s:wrap_object_brackets(type, ...) abort "{{{
  return s:wrap_object(']')
endfunction "}}}

nnoremap <silent> <leader>w :set opfunc=<sid>wrap_object_parens<cr>g@
nnoremap <silent> <leader>q :set opfunc=<sid>wrap_object_brackets<cr>g@

" same for visual
xmap <leader>w <leader>s)i
xmap <leader>b <leader>s]i
