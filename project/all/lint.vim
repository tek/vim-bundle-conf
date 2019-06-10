let s:type = get(g:, 'proteome_main_type', '')
if s:type == 'scala' || s:type == 'haskell'
elseif g:tek_neomake
  packadd neomake
  let g:neomake_ft_maker_remove_invalid_entries = 1
  call neomake#configure#automake('nrw', 500)
else
  packadd ale
endif
