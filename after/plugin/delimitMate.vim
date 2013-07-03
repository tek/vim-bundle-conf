" select completion entries with <cr>
if len(maparg('<Plug>delimitMateCR', 'i'))
  imap <expr> <CR> pumvisible() ? "\<c-n>" : "\<plug>delimitMateCR"
else
  inoremap <expr> <CR> pumvisible() ? "\<c-n>" : "\<cr>"
endif
