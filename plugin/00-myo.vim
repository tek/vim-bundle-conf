let g:myo_tmux_use_defaults = 1

let g:use_myo = exists('$MYO')

augroup myo
  autocmd User MyoRunCommand SaveAll
augroup END

nnoremap <silent> <f2> :MyoVimTest<cr>
nnoremap <silent> <f3> :MyoParse<cr>
nnoremap <silent> <f4> :MyoRunLatest<cr>
nnoremap <silent> <f9> :MyoTmuxOpenOrToggle main<cr>
nnoremap <silent> <leader>4 :MyoTmuxFocus make<cr>
nnoremap <silent> <leader>9 :MyoUniteHistory<cr>
nnoremap <silent> <f10> :MyoTmuxKill make<cr>
nnoremap <silent> <s-f10> :MyoTmuxPack<cr>
