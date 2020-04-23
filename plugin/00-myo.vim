nnoremap <silent> <f2> :call MyoVimTest()<cr>
nnoremap <silent> <f4> :call MyoReRun(0)<cr>
nnoremap <silent> <leader>9 :call MyoHistory()<cr>

augroup myo
  autocmd User MyoRunCommand SaveAll
augroup END

nnoremap <silent> <f3> :SaveAll<cr>:MyoParse<cr>
nnoremap <silent> <f9> :call MyoToggleLayout('make')<cr>
nnoremap <silent> <leader>4 :MyoFocus make<cr>

nnoremap <silent> <m--> :call MyoPrev()<cr>
nnoremap <silent> <m-=> :call MyoNext()<cr>

let g:myo_builtins_loaded = 0
autocmd User MyoBuiltinsLoaded let g:myo_builtins_loaded = 1
