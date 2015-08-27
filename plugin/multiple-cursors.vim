let g:multi_cursor_use_default_mapping = 1

function! Multiple_cursors_before()
  if has('nvim')
    " DeopleteLock
  else
    NeoCompleteLock
  endif
endfunction

function! Multiple_cursors_after()
  if has('nvim')
    " DeopleteUnlock
  else
    NeoCompleteUnlock
  endif
endfunction
