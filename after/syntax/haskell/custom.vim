highlight! HaskellType ctermfg=5 guifg=#a060c0
highlight! Constraint ctermfg=5 gui=bold guifg=#cb4b16
highlight! DiscreetSymbol ctermfg=6 gui=bold guifg=#586e75
highlight! DiscreetSymbol2 ctermfg=6 gui=bold guifg=#444444
highlight! Constructor ctermfg=6 gui=bold guifg=#a060c0
highlight! Constructor2 ctermfg=6 gui=bold guifg=#880000
highlight! HaskellResultType ctermfg=6 guifg=#d33682
highlight! IdentifierBold ctermfg=4 gui=bold guifg=#268bd2
highlight! KeywordBold gui=bold guifg=#719e07

highlight! link HsType HaskellType
highlight! link HsResultType HaskellResultType
highlight! link HsModuleName Type
highlight! link HsConstraintType Constraint
highlight! link HsModuleDot DiscreetSymbol2
highlight! link HsImportParens DiscreetSymbol2
highlight! link HsPatternParens DiscreetSymbol2
highlight! link HsParens DiscreetSymbol2
highlight! link HsImportType HsType
highlight! link HsImportSymbolicTypeName HsType
highlight! link HsSigConstraintClass Constraint
highlight! link HsSigConstraintParam HsResultType
highlight! link HsSigReturnType HsResultType
highlight! link HsCtor Constructor2
highlight! link HsCtorModule ModuleName
highlight! link HsDeclName IdentifierBold
