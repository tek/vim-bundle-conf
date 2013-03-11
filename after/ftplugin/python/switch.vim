let s:switch_definitions = 
    \ [ 
    \  ['extend', 'append']
    \ ]

if !exists('g:switch_definitions')
  let g:switch_definitions = []
endif
call extend(g:switch_definitions, s:switch_definitions)
