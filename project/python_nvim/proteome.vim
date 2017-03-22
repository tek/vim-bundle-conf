ProAdd python_nvim/ribosome
ProAdd python/amino

let g:test#runners = {
      \ 'python': ['Spec']
      \ }
let test#python#runner = 'spec'
let g:spec_unit = 'spec unit'
let g:spec_integration = 'spec integration'
