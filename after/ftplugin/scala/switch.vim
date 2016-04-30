let s:switch_definitions =
    \ [
    \   ['def', 'lazy val', 'val'],
    \   ['map', 'flatMap'],
    \   ['extends', 'with'],
    \   ['trait', 'abstract class'],
    \   ['case class', 'class']
    \ ]

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
call extend(b:switch_custom_definitions, s:switch_definitions)
