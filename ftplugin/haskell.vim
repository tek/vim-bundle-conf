setlocal formatexpr=hindent#Hindent()

nnoremap <buffer> <localleader>t :HdevtoolsType<cr>
nnoremap <buffer> <localleader>i :HdevtoolsInfo<cr>
nnoremap <buffer> <localleader>c :HdevtoolsClear<cr>

let g:ghcmod_use_basedir = getcwd()
