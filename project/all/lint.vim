if g:tek_neomake && g:proteome_project_name != 'scala'
  packadd benekastah/neomake
  let g:neomake_ft_maker_remove_invalid_entries = 1
  call neomake#configure#automake('nrw', 500)
else
  packadd w0rp/ale
endif
