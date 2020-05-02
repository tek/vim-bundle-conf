let g:ghcmod_use_basedir = getcwd()

setlocal suffixesadd+=.hs
setlocal includeexpr=substitute(v:fname,'\\.','/','g')

call haskell#marks#set()
augroup tek_haskell
  autocmd BufWritePost <buffer> call haskell#marks#set()
augroup END
