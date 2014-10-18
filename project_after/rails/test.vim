MaqueAddCapturedService 'puma -p 9294', {
      \ 'size': 20,
      \ 'start': 1,
      \ 'compiler': 'rspec',
      \ }
nnoremap <silent> <s-f4> :MaqueToggleCommand puma<cr>
nnoremap <silent> <s-f5> :MaqueRunCommand puma<cr>
