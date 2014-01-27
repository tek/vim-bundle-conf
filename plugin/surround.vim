" shortcut for surrounding inner word/WORD
nmap <leader>s csw
" nmap <leader>S csW
nmap <m-s> csW

function! Subround(char) "{{{
  execute 'normal ys'.g:subround_text_object.a:char
endfunction "}}}

let g:subround_text_object = 'iw'
call submode#enter_with('surround', 'n', 's', '<leader>S', ':let g:subround_text_object = "iw"<cr>')
call submode#map('surround', 'n', 'rs', "'", ":call Subround(\"'\")<cr>")
call submode#map('surround', 'n', 'rs', '"', ":call Subround(\'\"\')<cr>")
call submode#map('surround', 'n', 'rs', 'b', ":call Subround(\'b\')<cr>")
call submode#map('surround', 'n', 'rs', 'B', ":call Subround(\'B\')<cr>")
call submode#map('surround', 'n', 's', 'w', ':let g:subround_text_object = "iw"<cr>')
call submode#map('surround', 'n', 's', 'W', ':let g:subround_text_object = "iW"<cr>')
call submode#map('surround', 'n', 's', 'ib', ':let g:subround_text_object = "ib"<cr>')
call submode#map('surround', 'n', 's', 'ab', ':let g:subround_text_object = "ab"<cr>')
call submode#map('surround', 'n', 's', 'iB', ':let g:subround_text_object = "iB"<cr>')
call submode#map('surround', 'n', 's', 'aB', ':let g:subround_text_object = "aB"<cr>')
call submode#map('surround', 'n', 's', "i'", ":let g:subround_text_object = \"i'\"<cr>")
call submode#map('surround', 'n', 's', 'aB', ':let g:subround_text_object = "aB"<cr>')
