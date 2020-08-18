function! haskell#splitjoin#dot() abort "{{{
  let ws = indent('.')
  return tek_sj#single_line_with(' \. ', ' .\n' . repeat(' ', ws), 'g')
endfunction "}}}
