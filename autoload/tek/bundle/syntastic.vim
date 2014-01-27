function! tek#bundle#syntastic#cycle() abort "{{{
  if !exists('g:syntastic_checker_index')
    let g:syntastic_checker_index = -1
  endif
  if exists('g:syntastic_filetype_map') && has_key(g:syntastic_filetype_map, &filetype)
    let filetype = g:syntastic_filetype_map[&filetype]
  else
    let filetype = &filetype
  endif
  let checkers = g:SyntasticRegistry.Instance().availableCheckersFor(filetype)
  if len(checkers) > 0
    let g:syntastic_checker_index = (g:syntastic_checker_index + 1) % len(checkers)
    let checker = checkers[g:syntastic_checker_index]
    let g:syntastic_{filetype}_checkers = [checker._name]
    SyntasticCheck
    echo 'Using syntax checker "'.checker._name .'".'
  endif
endfunction "}}}
