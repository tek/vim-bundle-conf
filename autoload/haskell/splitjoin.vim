function! haskell#splitjoin#dot() abort "{{{
  let ws = indent('.')
  return tek_sj#single_line_with(' \. ', ' .\n' . repeat(' ', ws), 'g')
endfunction "}}}

function! haskell#splitjoin#instance_replacement(in) abort "{{{
   let [full, overlap, constraint_list, rest; ignore] = matchlist(a:in, '\vinstance\s*(\{.*\} )?\s*%((.*) \=\> )?(.*)')
   let line1 = 'instance ' . overlap . '('
   let constraints_without_parens = substitute(constraint_list, '\v%(^\(|\)$)', '', 'g')
   let constraints = split(constraints_without_parens, ',\zs\s*')
   let lines_c = map(constraints, { i, a -> text#indent(4, a) })
   let line_n = '  ) => ' . rest
   return join([line1] + lines_c + [line_n], "\n")
endfunction "}}}

function! haskell#splitjoin#instance() abort "{{{
  return tek_sj#single_line_with(
        \ 'instance .*',
        \ '\=haskell#splitjoin#instance_replacement(submatch(0))',
        \ '',
        \ )
endfunction "}}}
