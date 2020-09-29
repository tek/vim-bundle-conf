let b:switch_custom_definitions =
      \ [
      \   ['newtype', 'data'],
      \   ['<-', '=<<', '<$>'],
      \   {
      \     '\v^import qualified (\S+)( as \S+)?( \(.*)?$': 'import \1\3',
      \     '\v^import %(qualified )@!(\S+)\.([^. ]+)( \(.*)?$': 'import qualified \1.\2 as \2\3',
      \   },
      \   {
      \     '\v^import %(qualified )@!([^. ]+)( \(.*)?$': 'import qualified \1 as \1\2',
      \   },
      \   {
      \     '^\v\s+Members? .*': {
      \       '\vMembers \[([^,]*)\]': 'Member (\1)',
      \       '\vMember \((.*)\)': 'Members [\1]',
      \     },
      \   },
      \ ]

let g:switch_destructive += [
      \   {
      \     '\v^import qualified (\S+)( as \S+)?( \(.*)?$': 'import \1\3',
      \     '\v^import %(qualified )@!(\S+)\.([^. ]+)%( \(.*)?$': 'import qualified \1.\2 as \2',
      \   },
      \ ]
