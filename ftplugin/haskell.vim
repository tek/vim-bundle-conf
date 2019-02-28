nnoremap <buffer> <localleader>t :HdevtoolsType<cr>
nnoremap <buffer> <localleader>i :HdevtoolsInfo<cr>
nnoremap <buffer> <localleader>c :HdevtoolsClear<cr>
nnoremap <buffer><silent> gd :call LanguageClient_textDocument_definition()<cr>
nnoremap <silent> <localleader>m :call LanguageClient_contextMenu()<cr>
nnoremap <silent> <localleader>a :call LanguageClient_textDocument_codeAction()<cr>

let g:ghcmod_use_basedir = getcwd()

setlocal path+=lib
setlocal suffixesadd+=.hs
