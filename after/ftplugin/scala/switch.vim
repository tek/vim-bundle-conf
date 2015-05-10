let s:switch_definitions = 
    \ [ 
    \   ['def', 'val', 'var'],
    \ ]

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
call extend(b:switch_custom_definitions, s:switch_definitions)
