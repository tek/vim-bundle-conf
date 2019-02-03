let s:switch_definitions =
    \ [
    \   ['newtype', 'data'],
    \   {
    \     '\v^import (\S+)\.([^. ]+)( \(.*)?': 'import qualified \1.\2 as \2\3',
    \     '\v^import qualified (\S+)( as \S+)?( \(.*)?': 'import \1\3',
    \   },
    \ ]

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
call extend(b:switch_custom_definitions, s:switch_definitions)
