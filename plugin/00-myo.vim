let g:myo_plugins = [
      \ 'myo.plugins.command',
      \ 'myo.plugins.tmux',
      \ ]

let g:myo_tmux_use_defaults = 1

let g:use_myo = exists('$MYO')

if g:use_myo
  augroup myo
    autocmd User MyoRunCommand SaveAll
  augroup END

  map <silent> <f2> :MyoVimTest<cr>
  map <silent> <f3> :MyoParse<cr>
  nmap <silent> <f4> :MyoRunLatest<cr>
  nnoremap <silent> <leader>4 :MyoTmuxFocus make<cr>
endif
