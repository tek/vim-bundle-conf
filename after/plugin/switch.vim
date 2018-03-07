let s:switch_definitions =
    \ [
    \ {
    \   '\k\+ = ': 'return ',
    \   'return ': 'v = ',
    \   'dec\zeod': 'enc',
    \   'enc\zeod': 'dec',
    \   'Dec\zeod': 'Enc',
    \   'Enc\zeod': 'Dec',
    \ },
    \ ['yes', 'no'],
    \ ['on', 'off'],
    \ ['horizontal', 'vertical'],
    \ ['left', 'right'],
    \ ]

if !exists('g:switch_definitions')
  let g:switch_definitions = []
endif
call extend(g:switch_definitions, s:switch_definitions)
