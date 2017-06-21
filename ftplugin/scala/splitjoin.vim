if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = []
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = []
endif

let b:splitjoin_join_callbacks += [
      \ 'tek_sj#join_scala_function',
      \ 'tek_sj#join_scala_package_import',
      \ ]

let b:splitjoin_split_callbacks += [
      \ 'tek_sj#split_scala_function',
      \ 'tek_sj#split_scala_block',
      \ 'tek_sj#split_scala_package',
      \ 'tek_sj#split_scala_import',
      \ 'tek_sj#split_scala_params',
      \ ]
