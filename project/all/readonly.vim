if $PWD =~ '.*/code/tek/'
  let g:readonly_project = v:false
endif

function! s:save() abort "{{{
  noautocmd write
endfunction "}}}

if !g:readonly_project
  augroup tek_save_insert_leave
    autocmd!
    autocmd TextChanged * call s:save()
  augroup end
endif
