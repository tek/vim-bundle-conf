let s:switch_definitions =
    \ [
    \ {
    \   '\k\+ = yield': 'yield ',
    \   'yield ': 'v = yield',
    \ },
    \ ['flat_map', 'map'],
    \ ]

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
call extend(b:switch_custom_definitions, s:switch_definitions)
