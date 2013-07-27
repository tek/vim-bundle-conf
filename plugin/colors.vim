" let g:inkpot_black_background = 1

" if &t_Co > 8 || has('gui')
"   silent! colorscheme inkpot
" endif

if &t_Co > 8 || has('gui')
  set background=dark
  silent! colorscheme solarized
endif
