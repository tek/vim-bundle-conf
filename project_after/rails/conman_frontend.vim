MaqueAddCapturedService 'puma', { 'size': 20, 'start': 1 }
MaqueAddService 'bundle exec guard', { 'size': 20, 'start': 1,
      \ 'name': 'guard' }
MaqueAddCommand 'rake db:reset', { 'name': 'db:reset' }
MaqueAddCommand 'spring stop', { 'name': 'spring stop', 'capture': 0 }
nnoremap <silent> <s-f4> :MaqueToggleCommand puma<cr>
nnoremap <silent> <s-f9> :MaqueRunCommand puma<cr>
let g:maque_prefix_rspec = 'spring '
