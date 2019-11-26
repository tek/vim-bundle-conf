let s:switch_definitions =
    \ [
    \   ['val', 'def'],
    \   ['map', 'flatMap'],
    \   ['extends', 'with'],
    \   ['case class', 'case object'],
    \   ['trait', 'abstract class', 'class'],
    \   ['object', 'case class'],
    \ ]

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
call extend(b:switch_custom_definitions, s:switch_definitions)
