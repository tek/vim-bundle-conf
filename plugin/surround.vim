" shortcut for surrounding inner word/WORD
" nmap <leader>s csw
" nmap <leader>S csW
nmap <m-s> csW

function! Subround(char) "{{{
  execute 'normal ys'.g:subround_text_object.a:char
endfunction "}}}

let g:subround_text_object = 'iw'
call submode#enter_with('surround', 'n', 's', '<leader>s', ':let g:subround_text_object = "iw"<cr>')
call submode#map('surround', 'n', 'rs', "'", ":call Subround(\"'\")<cr>")
call submode#map('surround', 'n', 's', 'w', ':let g:subround_text_object = "iw"<cr>')
call submode#map('surround', 'n', 's', 'W', ':let g:subround_text_object = "iW"<cr>')
