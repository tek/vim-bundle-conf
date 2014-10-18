" shortcut for surrounding inner word/WORD
nmap <leader>s csw
" nmap <leader>S csW
nmap <m-s> csW

function! Subround(char) "{{{
  normal! m`
  keepjumps execute 'normal ys'.g:subround_text_object.a:char
  call feedkeys("\<c-o>")
endfunction "}}}

let g:subround_text_object = 'iw'
call submode#enter_with('surround', 'n', 's', '<leader>S', ':let g:subround_text_object = "iw"<cr>')
call submode#map('surround', 'n', 'rs', "'", ":call Subround(\"'\")<cr>")
call submode#map('surround', 'n', 'rs', '"', ":call Subround(\'\"\')<cr>")
call submode#map('surround', 'n', 'rs', 'b', ":call Subround(\'b\')<cr>")
call submode#map('surround', 'n', 'rs', 'B', ":call Subround(\'B\')<cr>")
call submode#map('surround', 'n', 's', 'w', ':let g:subround_text_object = "iw"<cr>')
call submode#map('surround', 'n', 's', 'W', ':let g:subround_text_object = "iW"<cr>')
call submode#map('surround', 'n', 's', 'ib', ':let g:subround_text_object = "ib"<cr>')
call submode#map('surround', 'n', 's', 'ab', ':let g:subround_text_object = "ab"<cr>')
call submode#map('surround', 'n', 's', 'iB', ':let g:subround_text_object = "iB"<cr>')
call submode#map('surround', 'n', 's', 'aB', ':let g:subround_text_object = "aB"<cr>')
call submode#map('surround', 'n', 's', "i'", ":let g:subround_text_object = \"i'\"<cr>")
call submode#map('surround', 'n', 's', 'aB', ':let g:subround_text_object = "aB"<cr>')

nmap <silent> <leader>C viwolB<Plug>VSurround)X

" remove/change function call, cursor on function name, leave args
nmap dC lbdt("_ds):call repeat#set('dC')<cr>
nnoremap cC lbct(

function! s:wrap(obj) "{{{
  exe "normal ysi".a:obj .')'
  startinsert
  call tek_misc#repeat_insert('ysi'.a:obj .')')
endfunction "}}}

" wrap word/WORD with a function call, leaving cursor in insert at the
" first paren
nnoremap <leader>ww :call <SID>wrap('w')<cr>
nnoremap <leader>wW :call <SID>wrap('W')<cr>

function! s:wrap_object(type, ...) abort "{{{
  silent exe "normal! `[v`]y"
  execute "normal gv\<Plug>VSurround)"
  startinsert
endfunction "}}}

nnoremap <silent> <leader>w :set opfunc=<sid>wrap_object<cr>g@

" same for visual
xmap <leader>w <leader>s)i

let g:surround_105 = "#{\r}"
