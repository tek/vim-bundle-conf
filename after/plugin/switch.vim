let s:switch_definitions = 
    \ [ 
    \ {
    \   '\k\+ = ': 'return ',
    \   'return ': 'value = ', 
    \ },
    \ ]

call extend(g:switch_definitions, s:switch_definitions)
