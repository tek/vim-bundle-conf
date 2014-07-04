" let g:maque_args_rspec_default = '--drb'
let g:rspec_backtrace = 0

function! Toggle_backtrace() "{{{
  let g:rspec_backtrace = !g:rspec_backtrace
  let g:maque_args_rspec_default = g:rspec_backtrace ? ' -b' : ''
  if exists('b:maque_args_rspec')
    let b:maque_args_rspec = g:rspec_backtrace ? ' -b' : ''
  end
  if exists('g:maque_args_rspec')
    let g:maque_args_rspec = g:rspec_backtrace ? ' -b' : ''
  end
endfunction "}}}

command -bar TB call Toggle_backtrace()

function! s:setup_maque() abort "{{{
  call maque#add_command('bundle', 'bundle install', { 'pane': 'main', })

  let pry = {
        \ 'eval_splitter': 0,
        \ '_splitter': 'tmux split-window -v -d -p 50', 
        \ 'capture': 0,
        \ 'autoclose': 0,
        \ 'vertical': 0,
        \ 'size': 15,
        \ 'minimized_size': 2,
        \ 'create_minimized': 0,
        \ 'restore_on_make': 0,
        \ 'focus_on_restore': 1,
        \ 'focus_on_make': 1,
        \ }
  let log = {
        \ '_splitter': 'tmux split-window -v -d -p 50', 
        \ 'capture': 0,
        \ 'vertical': 0,
        \ 'size': 10,
        \ 'minimized_size': 2,
        \ }
  call maque#tmux#add_pane_in_layout('pry', 'make', pry)
  call maque#tmux#add_pane_in_layout('log', 'make', log)

  call maque#add_command('pry', 'pry', { 'pane': 'pry', })
  call maque#add_command('rspec', 'rspec', { 'pane': 'main', })
  call maque#add_command('yard', 'yard', { 'pane': 'main', })
  call maque#add_command('log', 'tail -n 1000 -f log/development.log', {
        \ 'pane': 'log', })

  nnoremap <silent> <leader><f3> :SaveAll<cr>:MaqueRunCommand bundle<cr>
  nnoremap <silent> <leader><f4> :SaveAll<cr>:MaqueToggleCommand pry<cr>
  nnoremap <silent> <leader><f7> :SaveAll<cr>:MaqueToggleCommand log<cr>
endfunction

augroup maque_ruby_project
  autocmd!
  autocmd User MaqueTmuxPanesCreated call <sid>setup_maque()
augroup END
