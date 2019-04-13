let s:switch_definitions =
    \ [
    \ {
    \   '\k\+ = ': 'return ',
    \   'return ': 'v = ',
    \ },
    \ {
    \   'decod': 'encod',
    \   'encod': 'decod',
    \ },
    \ {
    \   'Decod': 'Encod',
    \   'Encod': 'Decod',
    \ },
    \ ['yes', 'no'],
    \ ['on', 'off'],
    \ ['horizontal', 'vertical'],
    \ ['left', 'right'],
    \ ['from', 'to'],
    \ ['stdin', 'stdout', 'stderr'],
    \ ]

if !exists('g:switch_definitions')
  let g:switch_definitions = []
endif
call extend(g:switch_definitions, s:switch_definitions)
