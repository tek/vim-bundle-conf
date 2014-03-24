function! tek#bundle#syntastic#cycle() abort "{{{
  if !exists('g:syntastic_checker_index')
    let g:syntastic_checker_index = -1
  endif
  if exists('g:syntastic_filetype_map') && has_key(g:syntastic_filetype_map, &filetype)
    let filetype = g:syntastic_filetype_map[&filetype]
  else
    let filetype = &filetype
  endif
  if exists('g:SyntasticRegistry')
    let checkers = keys(g:SyntasticRegistry.Instance().getCheckersMap(filetype))
    if len(checkers) > 0
      let g:syntastic_checker_index = (g:syntastic_checker_index + 1) % len(checkers)
      let checker = checkers[g:syntastic_checker_index]
      let g:syntastic_{filetype}_checkers = [checker]
      call tek_misc#warn('Using syntax checker "'.checker .'".')
      SyntasticCheck
      call tek_misc#warn('Using syntax checker "'.checker .'".')
    endif
  else
    echo 'Syntastic not available.'
  endif
endfunction "}}}
