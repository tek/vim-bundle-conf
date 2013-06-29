function! tek#bundle#syntastic#cycle() "{{{
  if !exists('g:syntastic_checker_index')
    let g:syntastic_checker_index = 0
  endif
  let checkers = g:SyntasticRegistry.Instance().availableCheckersFor(&filetype)
  let checkers = map(checkers, "v:val.getName()")
  if len(checkers) > 0
    let g:syntastic_checker_index = (g:syntastic_checker_index + 1) % len(checkers)
    let checker = checkers[g:syntastic_checker_index]
    let g:syntastic_{&ft}_checkers = [checker]
    SyntasticCheck
    echo 'Using syntax checker "'.checker.'".'
  endif
endfunction "}}}
