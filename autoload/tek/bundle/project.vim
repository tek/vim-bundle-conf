function! tek#bundle#project#is(name) abort "{{{
  return index(g:proteome_main_types, a:name) >= 0
endfunction "}}}
