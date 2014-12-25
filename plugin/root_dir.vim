let g:root_dirs = [$PWD]
let g:root_dir = 0

command! CPR call tek_bundle_misc#cycle_root_dir()

nnoremap <insert> :CPR<cr>

if expand('%:p') =~ $HOME && getcwd() == $HOME
  let dir = substitute(expand('%:p'), $HOME.'/[^/]\+/\zs.*', '', '')
  let g:root_dirs += [dir]
  call tek_bundle_misc#activate_root(-1)
endif

if expand('%:p') =~ '/etc'
  let g:root_dirs += ['/etc']
  call tek_bundle_misc#activate_root(-1)
endif
