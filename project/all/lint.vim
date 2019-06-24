let s:type = get(g:, 'proteome_main_type', '')
if s:type == 'scala' || s:type == 'haskell'
else
  packadd ale
endif
