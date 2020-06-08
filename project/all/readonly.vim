if $PWD =~ '.*/code/\%(tek\|spr\)/'
  let g:readonly_project = v:false
endif

function! s:save() abort "{{{
  if &modifiable && &buftype == '' && &modified
    let preserve = (get(g:, 'repeat_tick', -1) == b:changedtick)
    silent! noautocmd write
    if preserve
      let g:repeat_tick = b:changedtick
    endif
  endif
endfunction "}}}

if !g:readonly_project
  augroup tek_save_insert_leave
    autocmd!
    autocmd TextChanged * call s:save()
    autocmd InsertLeave * call s:save()
  augroup end
endif
