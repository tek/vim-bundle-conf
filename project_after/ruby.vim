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

let g:pry_command = get(g:, 'pry_command', 'pry')

MaqueAddCommand 'bundle install', { 'pane': 'main' }
" MaqueAddCommand 'yard'
MaqueAddCapturedService 'tail -n 1000 -f log/development.log',
      \ { 'name': 'log', 'compiler': 'rspec', 'create_minimized': 0 }
MaqueAddService g:pry_command, {
      \ 'name': 'pry',
      \ 'autoclose': 0,
      \ 'size': 20,
      \ 'minimized_size': 5,
      \ 'create_minimized': 0,
      \ 'focus_on_restore': 1,
      \ 'focus_on_make': 1,
      \ }

nnoremap <silent> <s-f1> :MaqueRunCommand bundle<cr>
nnoremap <silent> <s-f2> :MaqueToggleCommand pry<cr>
nnoremap <silent> <s-f3> :MaqueToggleCommand log<cr>
