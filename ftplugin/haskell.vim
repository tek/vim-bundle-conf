let g:ghcmod_use_basedir = getcwd()

setlocal path+=lib
setlocal suffixesadd+=.hs

call haskell#marks#set()
autocmd BufWritePost <buffer> call haskell#marks#set()
