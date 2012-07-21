let g:inkpot_black_background = 1

if &t_Co > 8 || has('gui')
  silent! colorscheme inkpot
endif
