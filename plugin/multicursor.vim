nnoremap <leader>mm :<c-u>call MultiCursorPlaceCursor()<cr>
nnoremap <leader>mg :<c-u>call MultiCursorManual()<cr>
nnoremap <leader>mr :<c-u>call MultiCursorRemoveCursors()<cr>
xnoremap <leader>m :<c-u>call MultiCursorVisual()<cr>
nnoremap <leader>ms :<c-u>call MultiCursorSearch('')<cr>
let g:multicursor_quit = "<leader>mq"
