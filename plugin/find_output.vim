let g:output_patterns = []
let g:output_file_patterns = []

function! Find_output() "{{{
  SaveAll
  let pat = join(g:output_patterns, '|')
  call ProGrep(pat)
endfunction "}}}

command! AP call Find_output()
