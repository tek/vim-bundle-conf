if !exists('$CRM_DEV')
  finish
endif

let g:myo_components = [
      \ 'ui',
      \ 'tmux',
      \ 'command',
      \ ]

nnoremap <silent> <f2> :MyoVimTest<cr>
nnoremap <silent> <f3> :MyoParse<cr>
nnoremap <silent> <f4> :MyoRerun<cr>
nnoremap <silent> <f9> :MyoTogglePane make<cr>
