if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = []
endif

let b:splitjoin_split_callbacks = [
      \ 'tek_sj#split_haskell_sig',
      \ 'tek_sj#split_haskell_decl',
      \ 'tek_sj#split_haskell_import',
      \ 'haskell#splitjoin#dot',
      \ 'haskell#splitjoin#instance',
      \ ]
