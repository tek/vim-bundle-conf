function! s:setup_maque() abort "{{{
  let pane = maque#tmux#pane('main')
  let pane.capture = 0
endfunction "}}}

augroup maque_zsh_project
  autocmd!
  autocmd User MaqueTmuxPanesCreated call <sid>setup_maque()
augroup END
