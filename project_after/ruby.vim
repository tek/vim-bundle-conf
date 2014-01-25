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

nnoremap <leader><f1> :SaveAll<cr>:MaqueRunCommand bundle<cr>
