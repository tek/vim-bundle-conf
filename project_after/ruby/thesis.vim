function! s:setup_maque() abort "{{{
  call maque#create_command('verbose', '''THESIS_VERBOSE=1 '' . maque#prg()', {
        \ 'cmd_type': 'eval',
        \ 'pane_type': 'eval',
        \ 'pane_name': 'maque#current_pane()',
        \ }
        \ )
  call maque#create_command('profile', '''RSPEC_PROFILE=each '' . maque#prg()', {
        \ 'cmd_type': 'eval',
        \ 'pane_type': 'eval',
        \ 'pane_name': 'maque#current_pane()',
        \ }
        \ )
  nnoremap <silent> <leader><f5> :SaveAll<cr>:MaqueRunCommand verbose<cr>
  nnoremap <silent> <leader><f6> :SaveAll<cr>:MaqueRunCommand profile<cr>
endfunction "}}}

augroup maque_ruby_project_thesis
  autocmd!
  autocmd User MaqueTmuxPanesCreated call <sid>setup_maque()
augroup END
