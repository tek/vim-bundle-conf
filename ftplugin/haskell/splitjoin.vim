let b:splitjoin_split_callbacks = [
      \ 'tek_sj#split_haskell_sig',
      \ 'tek_sj#split_haskell_decl',
      \ 'tek_sj#split_haskell_import',
      \ 'haskell#splitjoin#dot',
      \ 'haskell#splitjoin#instance',
      \ ] + b:splitjoin_split_callbacks
