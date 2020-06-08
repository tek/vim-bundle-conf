let g:undo_skip_max_lines = 1000

function! s:repeat_wrap_undo() abort "{{{
  let preserve = (get(g:, 'repeat_tick', -1) == b:changedtick)
  normal! u
  if preserve
    let g:repeat_tick = b:changedtick
  endif
endfunction "}}}

function! Undo(it) abort "{{{
  function! Lines() abort "{{{
    return nvim_buf_get_lines(0, 0, g:undo_skip_max_lines, v:false)
  endfunction "}}}
  if nvim_buf_line_count(0) < g:undo_skip_max_lines && a:it < 10
    let pre = Lines()
    call s:repeat_wrap_undo()
    let post = Lines()
    if pre == post
      return Undo(a:it + 1)
    endif
  else
    call s:repeat_wrap_undo()
  endif
endfunction "}}}

nmap <nop> <Plug>(RepeatUndo)
nnoremap u <cmd>call Undo(0)<cr>
