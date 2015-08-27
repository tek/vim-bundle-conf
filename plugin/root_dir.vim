let g:root_dirs = [$PWD]
let g:root_dir = 0

command! CPR call tek_bundle_misc#cycle_root_dir()
command! HomeRoot call tek_bundle_misc#home_root()

nnoremap <silent> <insert> :CPR<cr>
nnoremap <silent> <pageup> :HomeRoot<cr>

let s:fdir = expand('%:p:h')

if s:fdir =~ $HOME . '/' && getcwd() == $HOME
  let s:dir = substitute(s:fdir, $HOME.'/[^/]\+/\zs.*', '', '')
  let g:root_dirs += [s:dir]
  call tek_bundle_misc#activate_root(-1)
endif

if expand('%:p') =~ '^/etc'
  let g:root_dirs += ['/etc']
  call tek_bundle_misc#activate_root(-1)
endif

function! AddRootProjects(...) abort "{{{
  for d in a:000
    call tek_bundle_misc#add_root_project(d)
  endfor
endfunction "}}}
