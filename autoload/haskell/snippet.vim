function! haskell#snippet#derive_json_generic() abort "{{{
  let datadef = search('\v^%(data|newtype) ', 'Wbn')
  if datadef != 0
    let name = matchstr(getline(datadef), '\v^%(data|newtype) \zs\w+\ze')
    return "defaultJson ''" . name . "\nderiveGeneric ''" . name
  else
    return 'no data declaration'
  endif
endfunction "}}}

function! haskell#snippet#current_function() abort "{{{
  let eq = haskell#indent#function_equation(line('.'))
  if eq != -1
    return haskell#indent#function_name(eq)
  else
    return 'no function'
  endif
endfunction "}}}
