command! -buffer SortImports call haskell#sort_imports()

augroup tek_haskell_buffer
  autocmd BufWrite <buffer> SortImports
augroup END
