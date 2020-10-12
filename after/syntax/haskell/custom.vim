highlight! HaskellType ctermfg=5 guifg=#a060c0
highlight! Class ctermfg=5 gui=bold guifg=#a387af
highlight! DiscreetSymbol ctermfg=6 gui=bold guifg=#586e75
highlight! DiscreetSymbol2 ctermfg=6 gui=bold guifg=#444444
highlight! Constructor ctermfg=6 gui=bold guifg=#a060c0
highlight! IdentifierBold ctermfg=4 gui=bold guifg=#268bd2
highlight! KeywordBold gui=bold guifg=#719e07
highlight! Operator ctermfg=2 gui=bold guifg=#719e07

highlight! link HsTycon HaskellType
highlight! link HsModId Type
highlight! link HsModuleDot DiscreetSymbol2
highlight! link HsImportParens DiscreetSymbol2
highlight! link HsPatternParens DiscreetSymbol2
highlight! link HsBrackets DiscreetSymbol2
highlight! link HsClassName Class
highlight! link HsSigConstraintParam HsResultType
highlight! link HsSigReturnType HsResultType
highlight! link HsConId Constructor
highlight! link HsCtorModule ModuleName
highlight! link HsDeclName IdentifierBold
highlight! link HsImportKeyword Keyword
highlight! link HsPragma HsString

" debug

" highlight! Class ctermfg=5 gui=bold guifg=#cb4b16
" highlight! FunParamType ctermfg=6 guifg=#d33682
" highlight! Constructor ctermfg=6 gui=bold guifg=#880000
" highlight! link HsFunParamType FunParamType
