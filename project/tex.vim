nnoremap <silent> <leader><F5> :LatexView<cr>

set makeprg=latexmk

let s:central = $HOME . '/res/tex'

if isdirectory(s:central)
  let s:build_dir = s:central . '/' . g:project_name
  if !isdirectory(s:build_dir)
    execute 'silent! ! mkdir -p ' . s:build_dir
  endif
  if !isdirectory('build')
    execute 'silent! ! ln -s ' . s:build_dir . ' build'
  endif
endif

let g:neomake_tex_enabled_makers = ['chktex']
let g:latex_extra_args = ''
