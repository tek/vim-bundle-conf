if $PWD =~ '.*/code/\%(tek\|spr\)/'
  let g:readonly_project = v:false
endif

function! s:save() abort "{{{
  if &modifiable && &buftype == '' && &modified
    call repeat#wrap("\<cmd>silent! noautocmd write\<cr>", '')
  endif
endfunction "}}}

if !g:readonly_project
  augroup tek_save_insert_leave
    autocmd!
    autocmd TextChanged * call s:save()
    autocmd InsertLeave * call s:save()
  augroup end
endif
