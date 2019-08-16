" select completion entries with <cr>
if len(maparg('<Plug>delimitMateCR', 'i'))
  imap <expr> <cr> pumvisible() ? "\<c-y>" : "\<plug>delimitMateCR"
else
  inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<cr>"
endif
