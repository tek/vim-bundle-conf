setlocal formatexpr=hindent#Hindent()

nnoremap <buffer> <localleader>t :HdevtoolsType<cr>
nnoremap <buffer> <localleader>i :HdevtoolsInfo<cr>
nnoremap <buffer> <localleader>c :HdevtoolsClear<cr>
nnoremap <buffer><silent> gd :call LanguageClient_textDocument_definition()<cr>

let g:ghcmod_use_basedir = getcwd()
