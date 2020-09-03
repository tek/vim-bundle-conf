function! haskell#snippet#derive(f) abort "{{{
  let datadef = search('\v^%(data|newtype) ', 'Wbn')
  if datadef != 0
    let name = matchstr(getline(datadef), '\v^%(data|newtype) \zs\w+\ze')
    return call(a:f, [name])
  else
    return 'no data declaration'
  endif
endfunction "}}}

function! haskell#snippet#derive_json() abort "{{{
  return haskell#snippet#derive({ n -> "defaultJson ''" . n })
endfunction "}}}

function! haskell#snippet#derive_generic() abort "{{{
  return haskell#snippet#derive({ n -> "deriveGeneric ''" . n })
endfunction "}}}

function! haskell#snippet#derive_json_generic() abort "{{{
  return haskell#snippet#derive({ n -> "defaultJson ''" . n . "\nderiveGeneric ''" . n })
endfunction "}}}

function! haskell#snippet#current_function() abort "{{{
  let eq = haskell#indent#function_equation(line('.'))
  if eq != -1
    return haskell#indent#function_name(eq)
  else
    return 'no function'
  endif
endfunction "}}}
