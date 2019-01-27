nnoremap <buffer> <localleader>t :HdevtoolsType<cr>
nnoremap <buffer> <localleader>i :HdevtoolsInfo<cr>
nnoremap <buffer> <localleader>c :HdevtoolsClear<cr>
nnoremap <buffer><silent> gd :call LanguageClient_textDocument_definition()<cr>
nnoremap <buffer><silent> <m-i> :SaveAll<cr>:HsimportSymbol<cr>

let g:ghcmod_use_basedir = getcwd()

setlocal path+=lib
setlocal suffixesadd+=.hs
