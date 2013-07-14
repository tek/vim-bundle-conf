if !exists(':Tabularize')
  finish
endif

" aligns :command Foo call ... lines at the first cal
AddTabularPattern! com /\(^.*call.*\)\@<!\zscall/l1c1l0
AddTabularPattern! map /^[^:]*\zs:/l1c0l0
