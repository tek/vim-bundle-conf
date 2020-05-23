function! color#solarized() abort "{{{
  set pumblend=11
  highlight clear Pmenu
  highlight clear PmenuSel
  highlight clear PmenuSbar
  highlight clear PmenuThumb

  highlight link Pmenu Normal
  highlight Pmenu guifg=#839496 guibg=#002830
  highlight PmenuSel guifg=#839496 guibg=#772e25
  highlight PmenuSbar ctermfg=12 ctermbg=7 guifg=#839496 guibg=#503080
  highlight PmenuThumb ctermfg=8 ctermbg=12 guifg=#002b36 guibg=#8040a0
endfunction "}}}
