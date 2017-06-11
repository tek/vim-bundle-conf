let g:output_patterns = []
let g:output_file_patterns = []

function! Find_output() "{{{
  SaveAll
  let pat = join(g:output_patterns, '|')
  let fpat = join(map(g:output_file_patterns, '''\\ -g\\ '' . v:val'), '')
  execute 'Unite -auto-resize -no-quit grep:.:' . fpat . ':' . pat . ':'
endfunction "}}}

command! AP call Find_output()
