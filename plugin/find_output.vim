let g:output_patterns = []
let g:output_file_patterns = []

function! Find_output() "{{{
  SaveAll
  let pat = join(g:output_patterns, '|')
  let fpat = '-G (' . join(g:output_file_patterns, '|') . ')'
  call denite#start([{'name': 'grep', 'args': [[], fpat, pat]}])
endfunction "}}}

command! AP call Find_output()
