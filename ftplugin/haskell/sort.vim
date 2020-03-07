command! -buffer SortImports call haskell#impors#sort()

augroup tek_haskell_buffer
  autocmd BufWrite <buffer> call haskell#imports#sort_save()
augroup END
