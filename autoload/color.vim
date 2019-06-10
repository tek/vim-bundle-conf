function! color#solarized() abort "{{{
  set pumblend=11
  highlight clear Pmenu
  highlight clear PmenuSel
  highlight clear PmenuSbar
  highlight clear PmenuThumb

  highlight Pmenu ctermfg=12 ctermbg=0 guifg=#258590 guibg=#4b2468
  highlight PmenuSel ctermfg=12 ctermbg=7 guifg=#40a0b0 guibg=#682464
  highlight PmenuSbar ctermfg=12 ctermbg=7 guifg=#839496 guibg=#503080
  highlight PmenuThumb ctermfg=8 ctermbg=12 guifg=#002b36 guibg=#8040a0
endfunction "}}}
