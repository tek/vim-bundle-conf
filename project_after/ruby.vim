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

let g:ctrlp_custom_ignore['dir'] .= '|<%(profiles|log|doc|vendor/assets|tmp|coverage)>'
