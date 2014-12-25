let s:switch_definitions =
    \ [
    \ ['wrap_content', 'match_parent'],
    \ ]

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
call extend(b:switch_custom_definitions, s:switch_definitions)
