function! haskell#project#libs_name() abort "{{{
  return substitute(g:proteome_active.name, '^.', '\u&', '')
endfunction "}}}

function! haskell#project#lib_dir() abort "{{{
  return g:haskell_project_lib_prefix . '/' . haskell#project#libs_name()
endfunction "}}}
