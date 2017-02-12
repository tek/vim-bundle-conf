let g:myo_tmux_use_defaults = 1
let g:myo_output_window_max_size = 18
let g:myo_tmux_watcher_interval = 5

let g:use_myo = 1

augroup myo
  autocmd User MyoRunCommand SaveAll
augroup END

nnoremap <silent> <f2> :MyoVimTest<cr>
nnoremap <silent> <f3> :MyoParse<cr>
nnoremap <silent> <f4> :MyoRunLatest<cr>
nnoremap <silent> <f9> :MyoTmuxOpenOrToggle main<cr>
nnoremap <silent> <s-f9> :MyoTmuxToggle <vim><cr>
nnoremap <silent> <leader>4 :MyoTmuxFocus make<cr>
nnoremap <silent> <leader>9 :MyoUniteHistory<cr>
nnoremap <silent> <f10> :MyoTmuxKill make<cr>
nnoremap <silent> <s-f10> :MyoTmuxPack<cr>
nnoremap <silent> <leader><f1> :MyoUniteCommands<cr>
nnoremap <m--> :SaveAll<cr>:MyoEventPrev<cr>
nnoremap <m-=> :SaveAll<cr>:MyoEventNext<cr>
