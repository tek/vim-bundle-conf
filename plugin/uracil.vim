function! SafeUraPaste(mapping, rhs) abort "{{{
  if exists("*UraPaste")
    return call(a:rhs, [])
  else
    execute 'normal! ' . a:mapping
  endif
endfunction "}}}

nnoremap <silent> p <cmd>call SafeUraPaste('p', 'UraPaste')<cr>
xnoremap <silent> p <cmd>call SafeUraPaste('p', 'UraPaste')<cr>
nnoremap <silent> P <cmd>call SafeUraPaste('P', 'UraPpaste')<cr>
xnoremap <silent> P <cmd>call SafeUraPaste('P', 'UraPpaste')<cr>
nnoremap <silent> <m-y> :UraYankMenu<cr>

let g:uracil_paste_timeout = 3
