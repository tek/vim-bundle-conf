let g:maque_args_rspec_default = '--drb'
let g:rspec_backtrace = 0

function! Toggle_backtrace() "{{{
  let g:rspec_backtrace = !g:rspec_backtrace
  let g:maque_args_rspec_default = g:rspec_backtrace ? '--drb -b' : '--drb'
  if exists('b:maque_args_rspec')
    let b:maque_args_rspec = g:rspec_backtrace ? '--drb -b' : '--drb'
  end
  if exists('g:maque_args_rspec')
    let g:maque_args_rspec = g:rspec_backtrace ? '--drb -b' : '--drb'
  end
endfunction "}}}

command -bar TB call Toggle_backtrace()

call maque#add_command('bundle', 'bundle install', { 'pane': 'main', })

if !exists('g:maque_remote')
  let ipy = maque#tmux#add_pane('pry', {
        \ 'eval_splitter': 0,
        \ '_splitter': 'tmux split-window -v -d -p 50', 
        \ 'capture': 0,
        \ 'autoclose': 0,
        \ 'vertical': 0,
        \ 'size': 50,
        \ 'minimized_size': 2,
        \ 'create_minimized': 0,
        \ 'restore_on_make': 0,
        \ 'focus_on_restore': 1,
        \ 'focus_on_make': 1,
        \ }
        \ )

  call maque#add_command('pry', 'pry', { 'pane': 'pry', })
  call maque#add_command('rspec', 'rspec', { 'pane': 'main', })
endif

nnoremap <silent> <leader><f4> :SaveAll<cr>:MaqueRunCommand pry<cr>
nnoremap <silent> <f11> :MaqueToggleTmux pry<cr>
nnoremap <silent> <leader><f5> :SaveAll<cr>:MaqueToggleTmux main<cr>:MaqueRunCommand pry<cr>

nnoremap <leader><f3> :SaveAll<cr>:MaqueRunCommand bundle<cr>
