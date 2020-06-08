function! SafeUraPaste(mapping, rhs, args) abort "{{{
  if exists("*UraPaste")
    return call(a:rhs, a:args)
  else
    execute 'normal! ' . a:mapping
  endif
endfunction "}}}

nnoremap <silent> <m-p> <cmd>call SafeUraPaste('p', 'UraPasteFor', ["y"])<cr>
xnoremap <silent> <m-p> <cmd>call SafeUraPaste('p', 'UraPasteFor', ["y"])<cr>
nnoremap <silent> <m-s-p> <cmd>call SafeUraPaste('P', 'UraPpasteFor', ["y"])<cr>
xnoremap <silent> <m-s-p> <cmd>call SafeUraPaste('P', 'UraPpasteFor', ["y"])<cr>
nnoremap <silent> p <cmd>call SafeUraPaste('p', 'UraPaste', [])<cr>
xnoremap <silent> p <cmd>call SafeUraPaste('p', 'UraPaste', [])<cr>
nnoremap <silent> P <cmd>call SafeUraPaste('P', 'UraPpaste', [])<cr>
xnoremap <silent> P <cmd>call SafeUraPaste('P', 'UraPpaste', [])<cr>
nnoremap <silent> <m-y> :UraYankMenuFor<cr>
nnoremap <silent> <m-s-y> :UraYankMenuFor y<cr>

nnoremap <silent> <leader>p p
nnoremap <silent> <leader>P P

let g:uracil_paste_timeout = 3
