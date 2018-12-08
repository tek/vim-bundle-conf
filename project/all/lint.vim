let s:type = get(g:, 'proteome_main_type', '')
if g:tek_neomake && s:type != 'scala' && s:type != 'haskell'
  packadd neomake
  let g:neomake_ft_maker_remove_invalid_entries = 1
  call neomake#configure#automake('nrw', 500)
else
  packadd ale
endif
