let g:myo_components = [
      \ 'ui',
      \ 'tmux',
      \ 'command',
      \ ]

if get(g:, 'myo_hs', 0)
  nnoremap <silent> <f2> :call MyoVimTest()<cr>
  nnoremap <silent> <f4> :call MyoReRun(0)<cr>
  nnoremap <silent> <leader>9 :call MyoHistory()<cr>
else
  let g:myo_vim_pane_geometry = {
        \ 'fixed_size': 130,
        \ 'weight': 0.5,
        \ }
  nnoremap <silent> <f2> :MyoVimTest<cr>
  nnoremap <silent> <f4> :MyoRerun<cr>
  nnoremap <silent> <leader>9 :call MyoHistoryMenu()<cr>
endif

augroup myo
  autocmd User MyoRunCommand SaveAll
augroup END

nnoremap <silent> <f3> :SaveAll<cr>:MyoParse<cr>
nnoremap <silent> <f9> :call MyoToggleLayout('make')<cr>
nnoremap <silent> <leader>4 :MyoFocus make<cr>

if get(g:, 'myo_hs', 0)
  nnoremap <silent> <m--> :call MyoPrev()<cr>
  nnoremap <silent> <m-=> :call MyoNext()<cr>
endif
