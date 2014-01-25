let g:multi_cursor_use_default_mapping = 1

function! Multiple_cursors_before()
    NeoCompleteLock
endfunction

function! Multiple_cursors_after()
    NeoCompleteUnlock
endfunction
