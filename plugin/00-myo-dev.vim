if !g:crm_dev
  finish
endif

let g:myo_components = [
      \ 'ui',
      \ 'tmux',
      \ 'command',
      \ ]

let g:myo_vim_pane_geometry = {
      \ 'fixed_size': 130,
      \ 'weight': 0.5,
      \ }

augroup myo
  autocmd User MyoRunCommand SaveAll
augroup END

nnoremap <silent> <f2> :MyoVimTest<cr>
nnoremap <silent> <f3> :SaveAll<cr>:MyoParse<cr>
nnoremap <silent> <f4> :MyoRerun<cr>
nnoremap <silent> <f9> :MyoToggleLayout make<cr>
