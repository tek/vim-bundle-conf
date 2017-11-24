let s:switch_definitions =
    \ [
    \ {
    \   '\k\+ = ': 'return ',
    \   'return ': 'v = ',
    \   'dec\(\w\+\)': 'enc\1',
    \   'enc\(\w\+\)': 'dec\1',
    \ },
    \ ['yes', 'no'],
    \ ['horizontal', 'vertical'],
    \ ]

if !exists('g:switch_definitions')
  let g:switch_definitions = []
endif
call extend(g:switch_definitions, s:switch_definitions)
