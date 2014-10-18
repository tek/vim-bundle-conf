let s:switch_definitions = 
    \ [ 
    \ {
    \   '\k\+ = ': 'return ',
    \   'return ': 'value = ', 
    \ },
    \ ['yes', 'no'],
    \ ['horizontal', 'vertical'],
    \ ]

if !exists('g:switch_definitions')
  let g:switch_definitions = []
endif
call extend(g:switch_definitions, s:switch_definitions)
