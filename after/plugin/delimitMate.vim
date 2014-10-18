" select completion entries with <cr>
if len(maparg('<Plug>delimitMateCR', 'i'))
  imap <expr> <cr> pumvisible() ? "\<c-n>" : "\<plug>delimitMateCR"
else
  inoremap <expr> <cr> pumvisible() ? "\<c-n>" : "\<cr>"
endif
