let g:root_dirs = [$PWD]
let g:root_dir = 0

command! CPR call tek_bundle_misc#cycle_root_dir()

nnoremap <insert> :CPR<cr>

let s:fdir = expand('%:p:h')

if s:fdir =~ $HOME . '/' && getcwd() == $HOME
  let s:dir = substitute(s:fdir, $HOME.'/[^/]\+/\zs.*', '', '')
  let g:root_dirs += [s:dir]
  call tek_bundle_misc#activate_root(-1)
endif

if expand('%:p') =~ '/etc'
  let g:root_dirs += ['/etc']
  call tek_bundle_misc#activate_root(-1)
endif
