function! color#solarized() abort "{{{
  set pumblend=11
  highlight clear Pmenu
  highlight clear PmenuSel
  highlight clear PmenuSbar
  highlight clear PmenuThumb

  highlight Pmenu ctermfg=12 ctermbg=0 guifg=#839496 guibg=#073642
  highlight PmenuSel ctermfg=12 ctermbg=7 guifg=#839496 guibg=#205060
  highlight PmenuSbar ctermfg=12 ctermbg=7 guifg=#839496 guibg=#205060
  highlight PmenuThumb ctermfg=8 ctermbg=12 guifg=#002b36 guibg=#708080
endfunction "}}}
