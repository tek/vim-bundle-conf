let s:switch_definitions =
    \ [
    \ {
    \   '\k\+ = ': 'return ',
    \   'return ': 'v = ',
    \ },
    \ {
    \   'Decod': 'Encod',
    \   'Encod': 'Decod',
    \ },
    \ {
    \   'decod': 'encod',
    \   'encod': 'decod',
    \ },
    \ ['yes', 'no'],
    \ ['on', 'off'],
    \ ['horizontal', 'vertical'],
    \ ['left', 'right'],
    \ ['from', 'to'],
    \ ['stdin', 'stdout', 'stderr'],
    \ ['Right', 'Left'],
    \ switch#NormalizedCase(['sync', 'async']),
    \ ]

if !exists('g:switch_definitions')
  let g:switch_definitions = []
endif
call extend(g:switch_definitions, s:switch_definitions)
