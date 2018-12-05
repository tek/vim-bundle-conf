if g:tek_neomake && g:proteome_main_type != 'scala' && g:proteome_main_type != 'haskell'
  packadd neomake
  let g:neomake_ft_maker_remove_invalid_entries = 1
  call neomake#configure#automake('nrw', 500)
else
  packadd ale
endif
