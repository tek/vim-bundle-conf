setlocal grepprg=grep\ -nH\ $*
setlocal sw=2
setlocal ts=2

map <buffer> <f3> :wa<cr><leader>ll<cr>

map  <buffer> <leader>ll <Plug>Tex_Compile
nmap <buffer> <leader>lv <Plug>Tex_View
nmap <buffer> <leader>ls <Plug>Tex_ForwardSearch
nmap <buffer> <leader>rf <Plug>Tex_RefreshFolds
