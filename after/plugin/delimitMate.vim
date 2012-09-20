" select completion entries with <cr>
if len(maparg('<Plug>delimitMateCR', 'i'))
  imap <expr> <CR> pumvisible() ? "\<c-y>" : "\<plug>delimitMateCR"
else
  inoremap <expr> <CR> pumvisible() ? "\<c-y>" : "\<cr>"
endif
