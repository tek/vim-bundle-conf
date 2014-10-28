if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = []
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = []
endif

let b:splitjoin_join_callbacks += ['tek_sj#join_scala_function']
let b:splitjoin_split_callbacks += ['tek_sj#split_scala_function']
