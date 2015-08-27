function! tek#bundle#project#is(name) abort "{{{
  return index(g:project_types, a:name) >= 0
endfunction "}}}
