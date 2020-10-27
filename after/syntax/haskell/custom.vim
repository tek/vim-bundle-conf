highlight! HaskellType ctermfg=5 guifg=#a060c0
highlight! Class ctermfg=5 gui=bold guifg=#964090
highlight! DiscreetSymbol ctermfg=6 gui=bold guifg=#444444
highlight! Constructor ctermfg=6 gui=bold guifg=#a060c0
highlight! IdentifierBold ctermfg=4 gui=bold guifg=#268bd2
highlight! HsOperator ctermfg=2 gui=bold guifg=#719e07
highlight! HsReservedOperator ctermfg=2 gui=bold guifg=#719e07

highlight! link HsTycon HaskellType
highlight! link HsModId Type
highlight! link HsModuleDot DiscreetSymbol
highlight! link HsImportComma DiscreetSymbol
highlight! link HsImportParens DiscreetSymbol
highlight! link HsPatternParens DiscreetSymbol
highlight! link HsStrongBrackets Constant
highlight! link HsDiscreetBrackets DiscreetSymbol
highlight! link HsClassName Class
highlight! link HsSigConstraintParam HsResultType
highlight! link HsSigReturnType HsResultType
highlight! link HsConId Constructor
highlight! link HsCtorModule ModuleName
highlight! link HsDeclName IdentifierBold
highlight! link HsImportKeyword Keyword
highlight! link HsPragma HsString
highlight! link Conceal HsOperator

" debug

" highlight! Class ctermfg=5 gui=bold guifg=#cb4b16
" highlight! FunParamType ctermfg=6 guifg=#d33682
" highlight! Constructor ctermfg=6 gui=bold guifg=#880000
" highlight! link HsFunParamType FunParamType
