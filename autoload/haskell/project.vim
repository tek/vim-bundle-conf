function! haskell#project#libs_name() abort "{{{
  return substitute(g:proteome_active.name, '^.', '\u&', '')
endfunction "}}}
