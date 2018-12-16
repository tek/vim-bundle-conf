autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
let g:ncm2#complete_length = [[1, 3], [5, 1]]
