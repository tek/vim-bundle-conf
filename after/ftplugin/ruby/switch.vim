let s:switch_definitions = 
    \ [ 
    \ {
    \   '\(\w\+\)\.\(\w\+\)': '\1[:\2]',
    \   '\(\w\+\)\[:\(\w\+\)\]': '\1[''\2'']',
    \   '\v(\w+)\[''(\w+)''\]': '\1.\2',
    \ },
    \ ]

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
call extend(b:switch_custom_definitions, s:switch_definitions)
